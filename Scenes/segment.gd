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
	get_node("REGULAR/Cover").set_material_override(material)

func set_bad():
	get_node("REGULAR/StaticBody").add_to_group("bad")
	
func explode():	
	get_node("REGULAR/StaticBody").queue_free()
	get_node("REGULAR/AnimationPlayer").play("explode")

func meteorize():	
	get_node("REGULAR/StaticBody").queue_free()
	var mat = FixedMaterial.new()
	var color = get_tree().get_nodes_in_group("player")[0].color	
	mat.set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	get_node("REGULAR").set_material_override(mat)
	get_node("REGULAR/Cover").set_material_override(mat)