extends MeshInstance

onready var color = Color (get_tree().get_nodes_in_group("player")[0].color)

func _ready():		
	var mat = material_override.duplicate()			
	material_override = mat
	material_override.albedo_color = color	

func _on_OpacityTimer_timeout():
	if (color.a <= 0):
		queue_free()
	color.a -= 0.001	
	material_override.albedo_color = color

