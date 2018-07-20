extends Spatial

export(float) var velocity = 1

onready var children = get_node("Children")
onready var area = get_node("Area")

var segment = preload ("res://Scenes/Segment.tscn")

const SEGMENTS = 16
onready var offset = float(360) / SEGMENTS

func _ready():	
	
	var angle_offset = (randi() % 360 + 1)
	for i in range(0, 14):							
		var aux = segment.instance()
		aux.set_material (global.mat_regular)
			
		aux.rotate_y(deg2rad((offset * i) + angle_offset))
		children.add_child(aux)	

func explode():	
	area.queue_free()
	for child in children.get_children():
		child.explode()

func meteorize():	
	for child in children.get_children():
		child.meteorize()
	explode()
	
func _on_Area_body_enter( body ):
	body.get_parent().on_platform_passed()
	explode()