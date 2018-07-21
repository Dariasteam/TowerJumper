extends Area

var segment = preload ("res://Scenes/Regular_Segment.tscn")
const SEGMENTS = 16
onready var offset = float(360) / SEGMENTS

func _on_Area_body_enter( body ):
	body.get_parent().end_animation()
	get_node("StreamPlayer").play(1)
	disconnect("body_enter", self, "_on_Area_body_enter")
	set_enable_monitoring(false)
	get_node("Timer").start()	
	for child in get_node("Children").get_children():
		child.explode()
	
func _ready():
	for i in range(0, SEGMENTS):
		var aux = segment.instance()
		aux.set_material (global.mat_player)
		aux.rotate_y(deg2rad((offset * i)))
		get_node("Children").add_child(aux)

func meteorize():
	pass

func _on_Timer_timeout():	
	global.handl_win()
