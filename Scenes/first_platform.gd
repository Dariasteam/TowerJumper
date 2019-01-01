extends "res://abstract_platform.gd"

func _ready():	
		
	for i in range(0, 14):
		var aux = segment.instance()
		aux.set_material (global.mat_regular)
			
		aux.rotate_y(deg2rad(offset * i))
		children.add_child(aux)

	
func _on_Area_body_enter( body ):
	delete_enter (body)		
