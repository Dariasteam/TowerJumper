extends Spatial

var first_platform = preload ("res://Scenes/first_platform.tscn")
var platform = preload ("res://Scenes/platform.tscn")
var end_line = preload ("res://Scenes/end_line.tscn")

onready var col = get_node ("Column")

export(int) var space = 7
export(int) var n_platforms = 30

func instance_in (element, i):
	element.translate (Vector3(0, -1 * i * space , 0))
	add_child(element)

func _ready():	
	instance_in(first_platform.instance(), 0)	
	
	for i in range (1, n_platforms):
		instance_in(platform.instance(), i)		
		
	instance_in(end_line.instance(), n_platforms)
