extends Spatial

onready var axis = get_node ("Player")
onready var player = get_node ("Player")

func _ready():
	get_node("DirectionalLight").set_project_shadows(global.shadows_enabled)
	set_process(true)

func receive_input (rot):	
	return player._on_set_rotation (rot * 3)

func lock_rot():
	player.lock_rot()

func _process(delta):
	if (Input.is_action_pressed("ui_left")):
		player._on_set_rotation (-0.002)
	elif (Input.is_action_pressed("ui_right")):
		player._on_set_rotation (0.002)
		