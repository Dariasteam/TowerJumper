extends Control

onready var game = get_node ("Spatial")
onready var width = Globals.get("display/width")

var last_pos = 0
var is_pressed = false

func _ready():
	set_process_input(true)
	pass

func handle_pos (pos):	
	game.receive_input (pos)
	
	
func _input(event):	
	if (event.type==InputEvent.SCREEN_DRAG):
       handle_pos (float(-(event.pos.x - last_pos) * 100) / width)	
	
func _on_TouchScreenButton_pressed():	
	last_pos = get_local_mouse_pos().x
	game.lock_rot();

