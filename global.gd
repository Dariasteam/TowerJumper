extends Node

var mat_bad
var mat_regular
var mat_column
var mat_player

func handl_win():
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func handle_lose():
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")