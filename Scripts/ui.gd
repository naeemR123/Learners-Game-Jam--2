extends CanvasLayer

@onready var game := Game_Manager


@onready var label: Label = $Stats
@onready var turret_upgrade: Button = $HBoxContainer/TurretUpgrade
@onready var slow_down_upgrade: Button = $HBoxContainer/SlowDownUpgrade
@onready var defense_label: Label = $PlanetDefense


func _ready() -> void:
	game.resources_changed.connect(resource_label)
	game.defense_changed.connect(update_defense_ui)
	turret_button_refresh(0.2 * game.turret_upgrade_level)
	tractor_button_refresh()

func resource_label():
	update_ui()


func _on_turret_upgrade_pressed() -> void:
	
	if game.resources >= game.turret_upgrade_cost:
		game.resources -= game.turret_upgrade_cost
		
		var upgrade_amount = 0.2 * game.turret_upgrade_level
		game.update_firerate(upgrade_amount)
		
		game.turret_upgrade_level += 1
		
		game.turret_upgrade_cost = int(10 * pow(1.15,game.turret_upgrade_level))
		turret_button_refresh(upgrade_amount)

func turret_button_refresh(speed_amount):
	turret_upgrade.text = "Upgrade Turret Speed: +" + str(speed_amount) + "\nCost: " + str(game.turret_upgrade_cost)


func update_ui():
	var display_text = "Resource: " + str(game.resources)
	
	if game.turret_upgrade_level > 1:
		display_text += "\nTurret Level: " + str(game.turret_upgrade_level)
		
	if game.tractor_upgrade_level > 1:
		display_text += "\nTractor Level: " + str(game.tractor_upgrade_level)
	
	if game.defense_upgrade_level > 1:
		display_text += "\nPlanet Defense Level: " + str(game.defense_upgrade_level)
	
	label.text = display_text
	

func update_defense_ui():
	defense_label.text = "Defense:" + "\n- " + str(game.current_planet_defense) + " -"


func update_defense_button():
	pass


func _on_slow_down_upgrade_pressed() -> void:
	if game.resources >= game.tractor_upgrade_cost:
		if game.slow_down_amount <= 0.1:
			return
		game.resources -= game.tractor_upgrade_cost
		update_ui()
		
		game.slow_down_amount -= 0.05 * game.tractor_upgrade_level
		
		if game.slow_down_amount < 0.1:
			game.slow_down_amount = 0.1
		
		game.tractor_upgrade_level += 1
		game.tractor_upgrade_cost = int(10 * pow(1.15,game.tractor_upgrade_level))
		tractor_button_refresh()
		


func tractor_button_refresh():
	slow_down_upgrade.text =  "Upgrade Slow Down Speed: +" + str(0.05 * game.tractor_upgrade_level) + "\nCost: " + str(game.tractor_upgrade_cost)
