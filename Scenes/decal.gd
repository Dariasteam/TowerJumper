extends Quad

onready var color = Color (get_tree().get_nodes_in_group("player")[0].color)

func _ready():	
	var mat = get_material_override().duplicate()
	set_material_override(mat)
	get_material_override().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)

func _on_OpacityTimer_timeout():
	if (color.a <= 0):
		queue_free()
	color.a -= 0.001
	get_material_override().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
