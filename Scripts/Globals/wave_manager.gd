extends Node


var all_asteroids : Array[AsteroidData] = []



func _ready() -> void:
	register_all_asteroids()


# Scans the Asteroids folder and registers stats for every AsteroidData it find
func register_all_asteroids() -> void:
	
	# Routes access to Asteroids Resource folder, and returns if there is no folder
	var dir = DirAccess.open("res://Scripts/Resources/Asteroids/")
	if dir == null:
		push_error("Could not open Asteroids resource folder")
		return
	
	dir.list_dir_begin() # Start iterating over folder contents
	var file_name = dir.get_next()
	
	# Loops while there are non-blank files
	while file_name != "":
		# Only processes .tres files, skipping other file types
		if not dir.current_is_dir() and file_name.ends_with(".tres"):
			# Creates a file path with the specific resource file
			var path = "res://Scripts/Resources/Asteroids/" + file_name
			var resource = load(path)	# Loads that path
			
			# Safety check: makes sure it is a AsteroidData Resource
			if resource is AsteroidData:
				register_asteroids_stats(resource)	# Upon success, runs function to register it
			else:
				push_warning("Unexpected resource type in Asteroids folder: " + path)
			
		file_name = dir.get_next()
		
	dir.list_dir_end()	# CRITICAL : always needs to be called when done iterating


# Checks 'all_asteroids' for resource , if not found, adds it
func register_asteroids_stats(asteroid: AsteroidData) -> void:
	# Safe for multiple calls : won't overwrite if entry exists
	if not all_asteroids.has(asteroid):
		# Appends the AsteroidData resource to the array
		all_asteroids.append(asteroid)


func pick_asteroid_type(current_wave: int) -> AsteroidData:
	pass
