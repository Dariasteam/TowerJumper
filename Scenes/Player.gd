extends Spatial

onready var rigid = get_node("RigidBody")
onready var splash = get_node("RigidBody/Axis/Group/Splash")
onready var big_splash = get_node("RigidBody/Axis/Group/BigSplash")
onready var meteor_particles = get_node("RigidBody/Axis/Group/BigSplash")
onready var die_particles = get_node("RigidBody/Axis/Group/Die")
onready var idle_particles = get_node("RigidBody/Axis/Group/Idle")
onready var trail = get_node("RigidBody/Axis/Group/Trail")
onready var animation = get_node("RigidBody/Axis/Group/Ball/AnimationPlayer")
onready var axis = get_node ("RigidBody/Axis")
onready var ball = get_node ("RigidBody/Axis/Group/Ball")
onready var area = get_node ("RigidBody/Axis/Group/Area")
onready var rigid_2 = get_node("RigidBody2")
onready var light = get_node("RigidBody/Axis/Group/OmniLight")
onready var decal_raycast = get_node("RigidBody/Axis/DecalRayCast")

onready var camera_axis = get_node ("RigidBody2/CameraAxis")

onready var jump_sound = get_node("JumpSound")
onready var die_sound = get_node("DieSound")
onready var acceleration_sound = get_node("AccelerationSound")

var colliding = false

# number of complete loops made 
var rotation_acumulator = 0

var prev_frame_rotation = 0

var decal = preload("res://Scenes/decal.tscn")

onready var last_safe_rotation = axis.get_rotation().y

var counter = 0
var rotation_range = Vector2(0,0)
var movement_limited = false

export (int) var n_platforms_to_meteorize = 3

var meteor = false
var color

func limit_rotation_range(allowed_range):	
	movement_limited = true
	var first  = normalize_rot(allowed_range.x)
	var second = normalize_rot(allowed_range.y)
	rotation_range = Vector2(first, second)


func unlimit_rotation_range():	
	movement_limited = false

func _ready():
	global.player = self
	ball.set_material_override(global.mat_player)
	color = global.mat_player.get_parameter(FixedMaterial.PARAM_DIFFUSE)
	trail.get_material().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	trail.get_material().set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	trail.get_material().set_flag(FixedMaterial.FLAG_UNSHADED, true)
	light.set_color(1,color)

func die():
	trail.set_emitting(false)
	idle_particles.set_emitting(false)
	meteor_particles.set_emitting(false)
	splash.set_emitting(false)
	die_particles.set_emitting(false)

	rigid_2.set_sleeping(true)
	rigid.set_sleeping(true)
	
	if (global.sound_enabled):
		die_sound.play(0)
		
	big_splash.set_emitting(true)
	ball.queue_free()
	area.queue_free()	
	
	get_node("Timer").start()

func block_camera():
	rigid_2.set_sleeping(true)

func release_camera():	
	rigid_2.set_sleeping(false)	

func on_platform_passed():	
	release_camera()
	rigid_2.set_linear_velocity(rigid.get_linear_velocity())
		
	global.update_points((counter + 1) * 10)
	global.update_progress()
	
	if (counter == 1 and global.sound_enabled):
		acceleration_sound.play(1.5)
	
	counter += 1
	if (counter == n_platforms_to_meteorize - 1):
		rigid.set_gravity_scale(0)
	
	if (counter >= n_platforms_to_meteorize):
		meteor_particles.set_emitting(true)
		meteorize()
					

func lock_rot():	
	last_safe_rotation = axis.get_rotation_deg().y	

func normalize_rot(rot):	
	while (rot < 0):
		rot += 360
	while (rot > 360):
		rot -= 360
			
	return rot

func set_player_rotation (value):
	rotation_acumulator = int(value / 360)	
	axis.set_rotation_deg(Vector3(0,value,0))
	camera_axis.set_rotation_deg(Vector3(0,value,0))


func is_in_range (v, r_a, r_b):
	return v > r_a and v < r_b
			

func _on_set_rotation (rot):
	var intent_rotation = rot + last_safe_rotation
	var current_rotation = axis.get_rotation_deg().y;	

	var has_collided = false	
	var is_left = true	
	
	if (movement_limited):		
		# "Change basis" so first wall is at 180 degrees				
		var adjustment_offset = -rotation_range.x + (rotation_acumulator * 360)
		var local_normalized_intent_rotation = (intent_rotation + adjustment_offset)
		var local_current_rotation =           (current_rotation + adjustment_offset)
		var local_rotation_range = 			   Vector2 (rotation_range.x + (rotation_acumulator * 360), 0)
		
		# "Change basis" so second wall is at 180 degrees
		adjustment_offset = -rotation_range.y + (rotation_acumulator * 360)	
		var local_normalized_intent_rotation_2 = (intent_rotation + adjustment_offset)
		var local_current_rotation_2 =           (current_rotation + adjustment_offset)
		var local_rotation_range_2 =             Vector2(0, rotation_range.y + (rotation_acumulator * 360))
		
		print ("R ", local_rotation_range.x, " ", intent_rotation, " ", local_rotation_range_2.y)		
		
		if (intent_rotation > prev_frame_rotation):
			is_left = false
		
		if (is_in_range(local_current_rotation, local_rotation_range.x, local_rotation_range.y) and 100 < 8):
			var diff_a = abs(local_current_rotation - local_rotation_range.x)
			var diff_b = abs(local_current_rotation - local_rotation_range.y)
			
			if (diff_a < diff_b):
				intent_rotation = rotation_range.x
			else:
				intent_rotation = rotation_range.y
	
						
		#if (!is_left):  # FIRST SEGMENT
		if (current_rotation < local_rotation_range.x and intent_rotation > local_rotation_range.x):
			print (intent_rotation, " < ", local_rotation_range.x)
			intent_rotation = local_rotation_range.x - 1
			has_collided = true
		#else:			# SECOND SEGMENT
		if (current_rotation > local_rotation_range_2.y and intent_rotation < local_rotation_range_2.y):
			print (intent_rotation, " < ", local_rotation_range_2.y)
			intent_rotation = local_rotation_range_2.y + 1
			has_collided = true


	prev_frame_rotation = intent_rotation
	set_player_rotation(intent_rotation)
	return !has_collided

func end_animation():
	ball.queue_free()	
	rigid.set_linear_velocity(Vector3(0,0,0))
	rigid.set_gravity_scale(0)
	rigid_2.set_linear_velocity(Vector3(0,0,0))
	rigid_2.set_gravity_scale(0)
	idle_particles.set_emitting(false)
	trail.set_emitting(false)
	
	die_particles.set_emitting(true)
	
		
func _on_Area_body_enter(body):	
	rigid.set_linear_velocity(Vector3(0,0,0))

	light.set_enabled(false)
	acceleration_sound.stop()

	meteor_particles.set_emitting(false)
	rigid.set_gravity_scale(1)	
	
	var decal_collider = decal_raycast.get_collider();
	if (!meteor and decal_raycast.is_colliding() and decal_collider != null and decal_collider.is_in_group("bad")):
		die()
		
	else:
		if (meteor):
			unlimit_rotation_range()
			global.update_points(100)
			global.update_progress()
			body.get_parent().get_parent().get_parent().get_parent().meteorize()			
			big_splash.set_emitting(true)					
			rigid_2.apply_impulse(Vector3(0,0,0), Vector3(0,120,0))
			release_camera()
			rigid_2.apply_impulse(Vector3(0,0,0), Vector3(0,120,0))
		else:
			if (global.sound_enabled):
				jump_sound.play(0)
			var aux = decal.instance()
			body.get_parent().add_child(aux)
			var tr = aux.get_global_transform()
			tr.origin = decal_raycast.get_collision_point()
			aux.set_global_transform(tr)			
			aux.rotate_y(rand_range(0, 360))
			aux.translate(Vector3(0,0.001,0))
				
		
		rigid.apply_impulse(Vector3(0,0,0), Vector3(0,70,0))
		splash.set_emitting(true)
		animation.play("squeeze")
			
		counter = 0
		meteor = false
	
func power_up():
	ball.set_material_override(global.mat_power_up_1)
	color = global.mat_power_up_1.get_parameter(FixedMaterial.PARAM_DIFFUSE)
	trail.get_material().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	trail.get_material().set_fixed_flag(FixedMaterial.FLAG_USE_ALPHA, true)
	trail.get_material().set_flag(FixedMaterial.FLAG_UNSHADED, true)
	light.set_color(1,color)	
	

func meteorize():
	light.set_enabled(true)
	meteor = true	

func _on_Timer_timeout():
	global.handle_lose()

func _on_Area_body_exit( body ):	
	colliding = false

func _on_Area_area_enter( area ):	
	if (area.is_in_group("deleter") and !meteor):
		block_camera()
