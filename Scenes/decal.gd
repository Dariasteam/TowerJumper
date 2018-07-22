extends Quad

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var color = get_tree().get_nodes_in_group("player")[0].color
	get_material_override().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	pass


func _on_Timer_timeout():
	queue_free()
