extends Control

var enabled_pattern = []
var disabled_pattern = []

onready var sprite_list = get_node("Node2D").get_children()
onready var animator = get_node("Node2D/AnimationPlayer")

export(String) var config_name
export(String) var pattern_name

func select_color (colors, index):
	return colors [index]

func generate_patterns (colors, pattern_a, pattern_b):
	for i in range (0, 8):
		enabled_pattern.push_back(select_color (colors, pattern_a[i]))
		disabled_pattern.push_back(select_color (colors, pattern_b[i]))
	

func _ready():			
	var colors = global.current_palette
	global[config_name]
	
	var pattern_a = global[pattern_name].enabled
	var pattern_b = global[pattern_name].disabled
	
	generate_patterns(colors, pattern_a, pattern_b)
	
	change();

func change():
	var aux_pattern
	
	if (global[config_name]):
		aux_pattern = enabled_pattern
	else:
		aux_pattern = disabled_pattern
	
	for i in range (0, 8):
		sprite_list[i].set_modulate(aux_pattern[i])

func _on_Button_pressed():
	global[config_name] = !global[config_name]
	animator.play("Change")
	
