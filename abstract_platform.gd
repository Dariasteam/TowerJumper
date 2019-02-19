extends Spatial

onready var children = get_node("Children")
onready var area = get_node("Deleter")

var segment = preload ("res://Scenes/Regular_Segment.tscn")

var next_platform

var allowed_range = Vector3(-1,-1, -1)

const SEGMENTS = 16
onready var offset = float(360) / SEGMENTS
	
func send_next_platform_limits():
	if (next_platform.allowed_range != Vector3(-1,-1,-1)):		
		global.player.limit_rotation_range(next_platform.allowed_range)
	else:
		global.player.unlimit_rotation_range()

func explode():
	send_next_platform_limits()		
	for child in children.get_children():
		child.explode()

func meteorize():
	send_next_platform_limits()
	if (global.sound_enabled):
		get_node("BigExplosion").play()
	for child in children.get_children():
		child.meteorize()
	explode()

func delete_enter ( body ):
	if (!body.is_in_group("camera")):
		body.get_parent().on_platform_passed()
		if (global.sound_enabled):
			get_node("RegularExplosion").play()
		explode()
	
