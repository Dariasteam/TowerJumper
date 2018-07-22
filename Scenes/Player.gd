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

onready var camera_axis = get_node ("RigidBody2/CameraAxis")

onready var jump_sound = get_node("JumpSound")
onready var die_sound = get_node("DieSound")
onready var acceleration_sound = get_node("AccelerationSound")

var colliding = false

var decal = preload("res://Scenes/decal.tscn")

onready var rotation = axis.get_rotation_deg()
onready var last_safe_rotation = axis.get_rotation()
onready var collision_rotation = axis.get_rotation()

var counter = 0
var rotation_range = Vector2(0,0)
var movement_limited = false

export (int) var n_platforms_to_meteorize = 2

var meteor_charged = true
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
	
	
	rigid.set_gravity_scale(0)
	rigid_2.set_gravity_scale(0)
	rigid_2.set_linear_velocity(Vector3(0,0,0))
	rigid.set_linear_velocity(Vector3(0,0,0))
	rigid_2.set_sleeping(true)
	rigid.set_sleeping(true)
	
	die_sound.play(0)
	big_splash.set_emitting(true)
	ball.queue_free()
	area.queue_free()	
	
	get_node("Timer").start()
	

func on_platform_passed():
	unlimit_rotation_range()
	global.update_points((counter + 1) * 10)
	global.update_progress()
	
	if (counter == 1):
		acceleration_sound.play(2)
	
	counter += 1
	if (counter == n_platforms_to_meteorize - 1):
		rigid.set_gravity_scale(0)
	
	if (counter >= n_platforms_to_meteorize):				
		if (meteor_charged):
			meteor_particles.set_emitting(true)
			meteorize()
			
	rigid_2.set_sleeping(false)
	rigid_2.set_linear_velocity(rigid.get_linear_velocity())	

func lock_rot():
	last_safe_rotation = axis.get_rotation_deg()
	rotation = axis.get_rotation_deg()	

func normalize_rot(rot):
	var changed = true
	while (changed):
		changed = false
		if (rot >= 360):
			rot -= 360
			changed = true
		elif (rot < 0):
			rot += 360
			changed = true
			
	return rot
	
func is_in_range (v, r_a, r_b):
	if (r_a - r_b > 40):
		if (r_a < r_b):
			return (v < r_a or v > r_b)
		else:
			return (v < r_b or v > r_a)
	else:
		if (r_a < r_b):
			return (v > r_a and v < r_b)
		else:
			return (v > r_b and v < r_a)

func _on_set_rotation (rot):	
	var intent_rotation = normalize_rot(rot + last_safe_rotation.y)
		
	if (movement_limited and is_in_range(intent_rotation, rotation_range.x, rotation_range.y)):
		return false
				
	axis.set_rotation_deg(Vector3(0,intent_rotation,0))
	camera_axis.set_rotation_deg(Vector3(0,intent_rotation,0))

	return true

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
	light.set_enabled(false)
	acceleration_sound.stop()

	meteor_particles.set_emitting(false)
	rigid.set_gravity_scale(1)	
	
	if (!meteor_charged):
			meteor_charged = true
	
	if (body.is_in_group ("bad") && !meteor):
		die()
	else:
		if (meteor):
			unlimit_rotation_range()
			global.update_points(100)
			global.update_progress()
			body.get_parent().get_parent().get_parent().get_parent().meteorize()			
			meteor_charged = false
			big_splash.set_emitting(true)		
			rigid_2.set_linear_velocity(Vector3(0,0,0))
			rigid_2.apply_impulse(Vector3(0,0,0), Vector3(0,100,0))
		else:			
			jump_sound.play(0)
			var aux = decal.instance()
			body.get_parent().add_child(aux)
			var tr = aux.get_global_transform()
			tr.origin = get_node("RigidBody/Axis/DecalRayCast").get_collision_point()
			aux.set_global_transform(tr)			
			aux.rotate_y(rand_range(0, 360))
			aux.translate(Vector3(0,0.0001,0))
		
		
		rigid.set_linear_velocity(Vector3(0,0,0))
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
	meteor_charged = false	

func _on_Timer_timeout():
	global.handle_lose()

func _on_Area_body_exit( body ):
	colliding = false

