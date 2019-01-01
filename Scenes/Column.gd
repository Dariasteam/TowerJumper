extends Spatial

onready var axis = get_node ("Player")
onready var player = get_node ("Player")

func _ready():
	$DirectionalLight.shadow_enabled = global.shadows_enabled	
	set_process(true)

func receive_input (rot):	
	return player._on_set_rotation (rot)

func lock_rotation():
	player.lock_rotation()
