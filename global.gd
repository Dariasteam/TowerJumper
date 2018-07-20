extends Node

var mat_bad
var mat_regular
var mat_column
var mat_player
var total_points = 0
var progress = 0
var level_size = 29
var level = 0

signal update_points_viewer
signal update_progress

func handl_win():
	level += 1
	total_points = 0
	progress = 0
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func handle_lose():
	total_points = 0
	progress = 0
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func update_progress():
	progress += 1
	emit_signal("update_progress")
	
func update_points(addition):	
	total_points += addition	
	emit_signal("update_points_viewer", addition)	
	