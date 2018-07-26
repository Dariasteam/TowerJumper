extends Spatial

export(float) var velocity = 1

onready var children = get_node("Children")
onready var area = get_node("Area")

var segment = preload ("res://Scenes/Regular_Segment.tscn")

const SEGMENTS = 16
onready var offset = float(360) / SEGMENTS

func _ready():	
		
	for i in range(0, 14):
		var aux = segment.instance()
		aux.set_material (global.mat_regular)
			
		aux.rotate_y(deg2rad(offset * i))
		children.add_child(aux)

func explode():	
	get_node("StreamPlayer").play(0)
	for child in children.get_children():
		child.explode()
	area.queue_free()
	
func _on_Area_body_enter( body ):
	if (!body.is_in_group("camera")):
		body.get_parent().on_platform_passed()		
		explode()
	