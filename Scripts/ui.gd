extends CanvasLayer

@onready var game := Game_Manager


@onready var label: Label = $Label
@onready var upgrade_button: Button = $TurretUpgrade


func _ready() -> void:
	game.resources_changed.connect(resource_label)
	update_button(game.turret_fire_rate)
	

func resource_label(new_amount):
	update_ui(new_amount)


func _on_turret_upgrade_pressed() -> void:
	
	if game.resources >= game.turret_upgrade_cost:
		game.resources -= game.turret_upgrade_cost
		
		var upgrade_amount = 0.2 * game.turret_upgrade_level
		game.update_firerate(upgrade_amount)
		
		game.turret_upgrade_level += 1
		
		label.text = "Resources: " + str(game.resources) + "\nLevel: " + str(game.turret_upgrade_level)
		game.turret_upgrade_cost = game.turret_upgrade_cost * game.turret_upgrade_level
		update_button(upgrade_amount)

func update_button(speed_amount):
	upgrade_button.text = "Upgrade Turret Speed: +" + str(speed_amount) + "\nCost: " + str(game.turret_upgrade_cost)


func update_ui(new_amount):
	label.text = "Resources: " + str(new_amount) + "\nLevel: " + str(game.turret_upgrade_level)


func _on_slow_down_upgrade_pressed() -> void:
	pass
