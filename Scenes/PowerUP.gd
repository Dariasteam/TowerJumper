extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var color = global.mat_power_up_1.get_parameter(FixedMaterial.PARAM_DIFFUSE)
	get_node("Particles").get_material().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	


func _on_Area_area_enter( area ):
	OS.set_time_scale(0.4)
	get_tree().get_nodes_in_group("player")[0].power_up()
	get_node("Particles").set_emitting(false)
	get_node("Timer").start()


func _on_Timer_timeout():
	queue_free()
