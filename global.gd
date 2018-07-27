extends Node

var mat_bad = preload("res://Materials/mat_segment_bad.tres")
var mat_regular = preload("res://Materials/mat_segment_regular.tres") 
var mat_column = preload("res://Materials/mat_column.tres")
var mat_player = preload("res://Materials/mat_player.tres")
var mat_power_up_1

var environment_palette = []
var current_palette

var player

onready var shadows_enabled = true
onready var sound_enabled = true

var player_color = []
var decal_materials = []

var total_points = 0
var current_points = 0
var progress = 0
var level_size = 29
var level = 0

signal update_points_viewer
signal update_progress

func apply_random_palette():
	randomize()
	current_palette = environment_palette[randi() % environment_palette.size()]
	mat_regular.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(current_palette[0]))
	mat_bad.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(current_palette[1]))	
	mat_column.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(current_palette[2]))	

func handle_win():
	apply_random_palette()
	level += 1	
	progress = 0
	total_points += current_points
	current_points = 0
	save_game()
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func handle_lose():
	current_points = 0
	save_game()	
	progress = 0
	get_tree().change_scene("res://Scenes/Input_Handler.tscn")
	
func update_progress():
	progress += 1
	emit_signal("update_progress")
	
func update_points(addition):	
	current_points += addition	
	emit_signal("update_points_viewer", addition)	
	
func _ready():
	save_game()
	load_game()
	load_palette()
	apply_random_palette()

func load_palette():
	var palette = File.new()
	if !palette.file_exists("res://palette.json"):
		return #Error
		
	var content = {}
	palette.open("res://palette.json", File.READ)
	content.parse_json(palette.get_as_text())
	palette.close()
		
	for element in content["environment"]:
		environment_palette.push_back(element)
	
	mat_player.set_parameter(FixedMaterial.PARAM_DIFFUSE, Color(content["player"]))
	
func save_game():
	var savedict = {
		total_points = total_points,
		level = level,
		shadows_enabled = shadows_enabled,
		sound_enabled = sound_enabled
	}	
	
	var savegame = File.new()
	savegame.open("user://savegame.save", File.WRITE)	
	savegame.store_line(savedict.to_json())
	savegame.close()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load
		
	var currentline = {}
	savegame.open("user://savegame.save", File.READ)
	currentline.parse_json(savegame.get_line())
	total_points = currentline["total_points"]
	level = currentline["level"]
	shadows_enabled = currentline["shadows_enabled"]
	sound_enabled = currentline["sound_enabled"]
	savegame.close()

