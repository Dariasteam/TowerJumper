extends Control

onready var game = get_node ("Spatial")
onready var width = get_viewport_rect().size.x

var last_pos = 0
var touchs_vec = {}

func _ready():
	get_node("LevelLabel").set_text("Level " + str(global.level))
	set_process_input(true)

func handle_pos (pos):	
	var rot_pos = stepify(((-(pos - last_pos) * 300) / width), 0.1)
	if (!game.receive_input (rot_pos)):		
		game.lock_rotation();		
		last_pos = pos
		
func _input(event):	
	if (event is InputEventScreenTouch):
		print ("TOUCH")
		if (event.pressed):
			touchs_vec[event.index] = event.position.x
			if (touchs_vec.size() == 1):
				last_pos = event.position.x
				game.lock_rotation();
			
		else:		
			touchs_vec.erase(event.index)
			if (touchs_vec.size() == 1):
				last_pos = touchs_vec.values()[0]
				game.lock_rotation();
		
	elif (event is InputEventScreenDrag):
		touchs_vec[event.index] = event.position.x
		var a = event.position.x
		if (touchs_vec.size() == 1):
			handle_pos (event.position.x)
