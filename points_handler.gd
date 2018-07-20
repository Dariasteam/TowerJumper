extends Control

onready var total_points = get_node("TotalPoints")
onready var notifier = preload("res://Scenes/PointNotification.tscn")

func _ready():
	global.connect("update_points_viewer", self, "update_points")
	
	pass

func update_points(points):
	total_points.set_text(str(global.total_points))
	var aux = notifier.instance()
	aux.set_number(str(points))
	add_child(aux)