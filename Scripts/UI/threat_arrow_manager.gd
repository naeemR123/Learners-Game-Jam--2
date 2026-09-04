extends CanvasLayer



@onready var game := Game_Manager

const THREAT_ARROW = preload("uid://dybxnbaukeh6h")

const ASTEROID = "asteroid"
const SECONDS = "seconds"


# Exported for debugging
@export_category("Debug")
@export var is_unlocked : bool = false

@export_category("Arrow Settings")
@export var max_arrows : int = 20
@export var screen_margin : float = 25.0
@export var arrow_scale_min : float = 0.5
@export var arrow_scale_max : float = 1.5
@export var min_scale_seconds : float = 8
@export var max_scale_seconds : float = 0
@export var default_alpha : float = 0.15


var arrow_pool : Array[Node2D] = []		# Total arrows 
var arrow_assignments : Dictionary = {} # asteroid: arrow
var free_arrows : Array[Node2D] = []	# unassigned arrows

var tagged_asteroids : Array[Dictionary] = []	# Rebuilt every frame -> cleared, not accumulated

var unlock_id : String = UnlockIDs.THREAT_INDICATOR



func _ready() -> void:
	for i in max_arrows:
		var arrow = THREAT_ARROW.instantiate()
		add_child(arrow)
		arrow_pool.append(arrow)
		free_arrows.append(arrow)
		arrow.hide()
	
	game.feature_unlocked.connect(_on_feature_unlock)
	game.reset_unlocks.connect(reset)
	_refresh_unlock_status()


func _process(_delta: float) -> void:
	var cam = get_viewport().get_camera_2d()
	if cam == null: return
	
	_collect_threats(cam)				# Fills tagged_asteroids with off-screen, incoming asteroids
	var qualifying := _rank_threats()	# Sorts by urgency, returns the top max_arrows as { asteroid: seconds }
	_release_arrows(qualifying)			# Returns arrows whose asteroid died or no longer qualifies
	_assign_arrows(qualifying)			# Hands free arrows to newly qualifying asteroids
	_update_arrows(cam, qualifying)		# Positions, rotates, and scales each assigned arrow

## Checks to see if manager should unlock arrows | Called via _ready()
func _refresh_unlock_status() -> void:
	if game.is_feature_unlocked(unlock_id):
		is_unlocked = true
	set_process(is_unlocked)

## Checks if manager should unlock arrows | Called via signal game.feature_unlocked(unlock_id): emitted via game.purchase_perk()
func _on_feature_unlock(id: String) -> void:
	if id != unlock_id or is_unlocked: return
	is_unlocked = true
	set_process(is_unlocked)

## Fills tagged_asteroids with off-screen, incoming asteroids | Called via _process()
func _collect_threats(cam: Camera2D) -> void:
	# Keep before loop -- per-frame snapshot that needs to stay up-to-date
	# Keeping for longer than 1 frame has the potential to hold stale entries (freed asteroids)
	tagged_asteroids.clear()
	
	var center : Vector2 = cam.get_screen_center_position()
	var visible_size : Vector2 = get_viewport().get_visible_rect().size / cam.zoom
	var half : Vector2 = visible_size / 2.0
	var rect_min : Vector2 = center - half
	var rect_max : Vector2 = center + half
	
	var all_asteroids : Array[Node] = get_tree().get_nodes_in_group("Asteroids")
	
	for asteroid in all_asteroids:
		# Distance from the visible rect (world space size) per axis | 0 == inside the box (screen)
		var outside_x = max(rect_min.x - asteroid.global_position.x, 0.0, asteroid.global_position.x - rect_max.x)
		var outside_y = max(rect_min.y - asteroid.global_position.y, 0.0, asteroid.global_position.y - rect_max.y)
		#print(asteroid.global_position, " outside: ", outside_x, ", ", outside_y)
		var dist : float = Vector2(outside_x, outside_y).length()
		var to_center : Vector2 = (center - asteroid.global_position).normalized()
		
		if asteroid.direction.dot(to_center) <= 0: continue # Skips if asteroid has already past
		if asteroid.speed <= 0: continue	# Skips if asteroid is not moving or reverse
		if dist <= 0: continue	# Skips if already visible
		
		tagged_asteroids.append({
			ASTEROID: asteroid,
			SECONDS: dist / asteroid.speed, # World-space distance / world-units per second = seconds until reaches screen
		}) 

## Sorts by urgency, returns the top max_arrows as { asteroid: seconds } | Called via _process()
func _rank_threats() -> Dictionary:
	# Ascending, so the closest asteroid is index [0]
	tagged_asteroids.sort_custom(func(a, b): return a[SECONDS] < b[SECONDS])
	var visible_count : int = min(tagged_asteroids.size(), max_arrows)		# Provides the amount of possible arrows right now
	#print(tagged_asteroids.size(), " off-screen, showing ", visible_count)
	
	# Adds whatever asteroid is eligible (with all it's info - name and seconds away) to be tagged up to max
	# Returns the collected asteroids as a Dictionary
	var qualifying : Dictionary = {}
	for i in visible_count:
		qualifying[tagged_asteroids[i][ASTEROID]] = tagged_asteroids[i][SECONDS]
	return qualifying

## Returns arrows whose asteroid died or no longer qualifies | Called via _process()
func _release_arrows(qualifying: Dictionary) -> void:
	# Goes through each asteroid in the assigned arrows and re-evaluates its eligibility to see if any can be freed
	# If so, hides it and moves it from arrow_assignements to free_arrows
	for asteroid in arrow_assignments.keys():
		if is_instance_valid(asteroid) and qualifying.has(asteroid): continue
		var arrow = arrow_assignments[asteroid]
		arrow.hide()
		arrow.modulate.a = default_alpha	# Resets blink() incase interrupted mid-fade
		free_arrows.append(arrow)
		arrow_assignments.erase(asteroid)	# .keys() returns copies so erasing is safe

## Hands free arrows to newly qualifying asteroids | Called via _process()
func _assign_arrows(qualifying: Dictionary) -> void:
	# Goes through each asteroid in the qualifying dictionary and checks its eligibility to add arrows: 
	# Checks if it already has an arrow and if there is any free arrows to add. If so, adds the arrow and asteroid to
	# arrow_assigments, shows the arrow, and runs the blink animation
	for asteroid in qualifying:
		if arrow_assignments.has(asteroid): continue
		if free_arrows.is_empty(): break
		var arrow = free_arrows.pop_back()
		arrow_assignments[asteroid] = arrow
		arrow.show()
		arrow.blink()

## Positions, rotates, and scales each assigned arrow | Called via _process()
func _update_arrows(cam: Camera2D, qualifying: Dictionary) -> void:
	var center : Vector2 = cam.get_screen_center_position()
	var screen_size : Vector2 = get_viewport().get_visible_rect().size
	var screen_center : Vector2 = screen_size / 2
	var screen_half : Vector2 = screen_center - Vector2(screen_margin, screen_margin)
	
	# Loops every asteroid in the updated assigned list; Sets the properties
	# for each arrow attached to the asteroids in arrow_assignments.
	for asteroid in arrow_assignments:
		var arrow = arrow_assignments[asteroid]
		
		var direction : Vector2 = (asteroid.global_position - center).normalized()	# Direction always normalized
		arrow.rotation = direction.angle() + deg_to_rad(90)
		
		# Grabs whichever screen edge the ray hits first
		var scale_factor : float = min(screen_half.x/maxf(abs(direction.x), 0.000001), screen_half.y/maxf(abs(direction.y), 0.000001))
		arrow.position = screen_center + direction * scale_factor
		
		var seconds = qualifying[asteroid]
		arrow.scale = Vector2.ONE * clampf(remap(seconds, max_scale_seconds, min_scale_seconds, arrow_scale_max, arrow_scale_min), arrow_scale_min, arrow_scale_max)

## Resets manager to defaults | Called via signal reset_unlocks(): emitted via game.game_reset()
func reset() -> void:
	arrow_assignments.clear()
	free_arrows.clear()
	for arrow in arrow_pool:
		arrow.hide()
		free_arrows.append(arrow)
	is_unlocked = false
	set_process(is_unlocked)
