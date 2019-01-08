extends Control

onready var col = get_node("HBoxContainer/GridContainer/col_edit")
onready var good = get_node("HBoxContainer/GridContainer/good_edit")
onready var bad = get_node("HBoxContainer/GridContainer/bad_edit")

var game_scene = preload ("res://Scenes/Column.tscn")

onready var sp = get_node("Spatial")

func _ready():	
	pass

func _on_Apply_Button_pressed():
	var color_col = Color(col.get_text())
	var color_good = Color(good.get_text())
	var color_bad = Color(bad.get_text())
	
	global.mat_regular.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(color_good))
	global.mat_bad.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(color_bad))	
	global.mat_column.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(color_col))
	
	sp.queue_free()
	sp = game_scene.instance()	
	add_child(sp)
	

func _on_Dark_Button_pressed():
	pass # replace with function body
