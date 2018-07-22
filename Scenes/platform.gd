extends Spatial

export(float) var velocity = 1

onready var children = get_node("Children")
onready var area = get_node("Deleter")

var segment = preload ("res://Scenes/Regular_Segment.tscn")
var segment_tall = preload ("res://Scenes/Segment_Tall.tscn")
var segment_movement = preload ("res://Scenes/Segment_Double.tscn")

var allowed_range = Vector2(-1,-1)

const SEGMENTS = 16
onready var offset = float(360) / SEGMENTS

func _ready():
	randomize()
	var angle_offset = 0 #(randi() % 360 + 1)
	var cant_move = false
	
	for i in range(0, 14):		
		var aux = null
		var rand = (randi()%20+1)
		var rot = ((offset * i) + angle_offset) + 7
		
		if (rand >= 17):
			aux = segment.instance()
			aux.set_bad()
			aux.set_material (global.mat_bad)
		elif (rand >= 16):
			aux = segment_movement.instance()
			aux.set_translation(Vector3(0,rand_range(-0.01, 0.01), 0))
			aux.set_material (global.mat_regular)
		elif (rand == 15 and !cant_move):						
			allowed_range = Vector2(rot - offset - 14, rot + 7)			
			cant_move = true
			aux = segment_tall.instance()
			aux.set_material (global.mat_regular)
		elif (rand > 1):
			aux = segment.instance()
			aux.set_material (global.mat_regular)
			
		
		if (aux != null):			
			aux.set_rotation_deg(Vector3(0,rot,0))
			children.add_child(aux)
	
	if (!cant_move):
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
	get_node("RegularExplosion").play(1)
	area.queue_free()
	for child in children.get_children():
		child.explode()

func meteorize():	
	get_node("BigExplosion").play()
	for child in children.get_children():
		child.meteorize()
	explode()

func _on_Init_body_enter( body ):
	if (allowed_range != Vector2(-1,-1)):
		global.player.limit_rotation_range(allowed_range)
	else:
		global.player.unlimit_rotation_range()

func _on_Deleter_body_enter( body ):
	if (!body.is_in_group("camera")):
		body.get_parent().on_platform_passed()
		explode()
	else:
		body.set_sleeping(true)
