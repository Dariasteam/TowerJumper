extends "res://abstract_platform.gd"

export(float) var velocity = 1

var segment_tall = preload ("res://Scenes/Segment_Tall.tscn")
var segment_movement = preload ("res://Scenes/Segment_Double.tscn")

func _ready():
	
	randomize()
	var angle_offset = (randi() % 360 + 1)
	var cant_move = false
	
	for i in range(0, 14):
		var aux = null
		var rand = (randi()% 20+1)
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
			var segment_width = offset / 2;
			allowed_range = Vector2(rot - offset - segment_width, rot - 2)
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

func send_next_platform_limits():
	if (next_platform.allowed_range != Vector2(-1,-1)):		
		global.player.limit_rotation_range(next_platform.allowed_range)
	else:
		global.player.unlimit_rotation_range()

func explode():
	send_next_platform_limits()	
	area.queue_free()
	for child in children.get_children():
		child.explode()

func meteorize():
	send_next_platform_limits()
	if (global.sound_enabled):
		get_node("BigExplosion").play()
	for child in children.get_children():
		child.meteorize()
	explode()

func _on_Deleter_body_enter( body ):
	delete_enter (body)	
	
	
