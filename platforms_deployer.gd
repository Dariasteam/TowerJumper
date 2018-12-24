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
	var prev_platform = first_platform.instance()
	instance_in(prev_platform, 0)		

	if (global.level > 16):
		n_platforms += ((global.level - 16) / 2) 
		global.level_size = n_platforms
		
	col.set_scale(Vector3(col.get_scale().x, col.get_scale().y * n_platforms, col.get_scale().z))
	col.set_translation(Vector3 (0, -(n_platforms * space / 2) + 0.5, 0))
	
	print (-(n_platforms * space))
		
	for i in range (1, n_platforms):
		var new_platform = platform.instance();
		prev_platform.next_platform = new_platform
		instance_in(new_platform, i)
		prev_platform = new_platform
		
	var end = end_line.instance()
	prev_platform.next_platform = end
	instance_in(end, n_platforms)
	
