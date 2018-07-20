extends Spatial

onready var axis = get_node ("Player")
onready var player = get_node ("Player")

func _ready():		
	set_process(true)

func receive_input (rot):	
	player._on_set_rotation (rot * 0.05)

func lock_rot():
	player.lock_rot()

func _process(delta):	
	#axis.set_rotation(Vector3(0,0.001,0))
	
	if (Input.is_action_pressed("ui_left")):
		player._on_set_rotation (-0.002)
	elif (Input.is_action_pressed("ui_right")):
		player._on_set_rotation (0.002)
		