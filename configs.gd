extends Spatial

export (Color) var color_regular
export (Color) var color_bad
export (Color) var color_column
export (Color) var color_player
export (Color) var color_power_up_1

func _ready():	
	global.mat_bad = FixedMaterial.new()
	global.mat_regular = FixedMaterial.new()
	global.mat_column = FixedMaterial.new()
	global.mat_player = FixedMaterial.new()
	global.mat_power_up_1 = FixedMaterial.new()
	
	global.mat_bad.set_parameter(FixedMaterial.PARAM_DIFFUSE, color_bad)
	global.mat_regular.set_parameter(FixedMaterial.PARAM_DIFFUSE, color_regular)
	global.mat_column.set_parameter(FixedMaterial.PARAM_DIFFUSE, color_column)
	global.mat_player.set_parameter(FixedMaterial.PARAM_DIFFUSE, color_player)
	global.mat_power_up_1.set_parameter(FixedMaterial.PARAM_DIFFUSE, color_power_up_1)
	global.mat_power_up_1.set_flag(FixedMaterial.FLAG_UNSHADED, true)
	global.mat_power_up_1.set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	
	get_node("../Axis/Column").set_material_override(global.mat_column)
