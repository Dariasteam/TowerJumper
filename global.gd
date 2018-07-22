extends Node

var mat_bad
var mat_regular
var mat_column
var mat_player
var mat_power_up_1

var player

var player_color = []
var decal_materials = []

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
	save_game()
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func handle_lose():
	save_game()
	total_points = 0
	progress = 0
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func update_progress():
	progress += 1
	emit_signal("update_progress")
	
func update_points(addition):	
	total_points += addition	
	emit_signal("update_points_viewer", addition)	
	
	
func save_game():
	var savedict = {
		total_points = total_points,
		level = level
	}	
	
	var savegame = File.new()
	savegame.open("user://savegame.save", File.WRITE)	
	savegame.store_line(savedict.to_json())
	savegame.close()

	
func _ready():
	load_game()
	
func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
		
	var currentline = {}
	savegame.open("user://savegame.save", File.READ)
	currentline.parse_json(savegame.get_line())	
	total_points = currentline["total_points"]
	level = currentline["level"]
	savegame.close()

