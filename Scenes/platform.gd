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
		var aux = null
		var rand = (randi()%11+1)
		
		if (rand > 9):
			aux = segment.instance()
			aux.set_bad()
			aux.set_material (global.mat_bad)
		elif (rand > 5):
			aux = segment.instance()
			aux.set_material (global.mat_regular)
		
		if (aux != null):
			aux.rotate_y(deg2rad((offset * i) + angle_offset))
			children.add_child(aux)		
	
	var rand = (randi()%4)
	if (rand < 1):
		randomize()
		rand = rand_range(-5,5)
		if (abs(rand) > 2):
			velocity = rand
			set_process(true)
	
func _process(delta):
	rotate(Vector3(0,1,0), velocity * 0.0003)

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