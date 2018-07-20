extends Spatial

var velocity = 0

func _ready():	
	randomize()	
	velocity = rand_range(-10,10)	
	set_process(true)
	
func _process(delta):
	rotate(Vector3(0,1,0), velocity * 0.0003)
	
func set_material(material):	
	get_node("REGULAR").set_material_override(material)	

func set_bad():
	get_node("REGULAR/StaticBody").add_to_group("bad")
	
func explode():	
	get_node("REGULAR/AnimationPlayer").play("explode")

func meteorize():	
	get_node("REGULAR").set_material_override(global.mat_player)	