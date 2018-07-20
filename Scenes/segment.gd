extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func set_material(material):	
	get_node("REGULAR").set_material_override(material)	

func set_bad():
	get_node("REGULAR/StaticBody").add_to_group("bad")
	
func explode():
	get_node("REGULAR/AnimationPlayer").play("explode")

func meteorize():
	get_node("REGULAR").set_material_override(global.mat_player)	