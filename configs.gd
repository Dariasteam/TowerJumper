extends Spatial

export (Color) var color_regular
export (Color) var color_bad
export (Color) var color_column
export (Color) var color_player

func _ready():	
	global.mat_bad = FixedMaterial.new()
	global.mat_regular = FixedMaterial.new()
	global.mat_column = FixedMaterial.new()
	global.mat_player = FixedMaterial.new()
	
	global.mat_bad.set_parameter(global.mat_bad.PARAM_DIFFUSE, color_bad)
	global.mat_regular.set_parameter(global.mat_regular.PARAM_DIFFUSE, color_regular)
	global.mat_column.set_parameter(global.mat_column.PARAM_DIFFUSE, color_column)
	global.mat_player.set_parameter(global.mat_player.PARAM_DIFFUSE, color_player)
	
	get_node("../Axis/Column").set_material_override(global.mat_column)
