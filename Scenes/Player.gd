extends Spatial

onready var rigid = get_node("RigidBody")
onready var splash = get_node("RigidBody/Axis/Group/Splash")
onready var big_splash = get_node("RigidBody/Axis/Group/BigSplash")
onready var meteor_particles = get_node("RigidBody/Axis/Group/BigSplash")
onready var trail = get_node("RigidBody/Axis/Group/Trail")
onready var animation = get_node("RigidBody/Axis/Group/Ball/AnimationPlayer")
onready var axis = get_node ("RigidBody/Axis")
onready var ball = get_node ("RigidBody/Axis/Group/Ball")

var decal = preload("res://Scenes/decal.tscn")

onready var rotation = axis.get_rotation_deg()

var counter = 0

export (int) var n_platforms_to_meteorize = 3

var meteor_charged = true
var meteor = false

func on_platform_passed():
	counter += 1
	meteor_particles.set_emitting(true)
	rigid.set_gravity_scale(0.5)
	
	if (counter >= n_platforms_to_meteorize and meteor_charged):
		meteorize()		
			
	
func lock_rot():	
	rotation = axis.get_rotation()

func _on_set_rotation (rot):
	axis.set_rotation(rotation + Vector3(0,rot,0))
		
func _on_Area_body_enter(body):
	meteor_particles.set_emitting(false)
	rigid.set_gravity_scale(1)
	if (body.is_in_group ("bad") && !meteor):
		global.handle_lose()
	else:
		if (meteor):
			body.get_parent().get_parent().get_parent().get_parent().meteorize()
			meteor = false
			meteor_charged = false
			big_splash.set_emitting(true)
		elif (!meteor_charged):
			meteor_charged = true


		var aux = decal.instance()
		#var vec = Vector3(0, 0.4, 0)
		aux.set_translation(Vector3(-0.45, 0.5, 0.6))
		#aux.translate(vec)
		body.add_child(aux)		

		rigid.set_linear_velocity(Vector3(0,0,0))		
		rigid.apply_impulse(Vector3(0,0,0), Vector3(0,70,0))
		splash.set_emitting(true)
		animation.play("squeeze")
		counter = 0
	
func _ready():
	ball.set_material_override(global.mat_player)
	var color = global.mat_player.get_parameter(FixedMaterial.PARAM_DIFFUSE)
	trail.get_material().set_parameter(FixedMaterial.PARAM_DIFFUSE, color)
	
func meteorize():	
	meteor = true		
	counter = 0	
	meteor_charged = false
	
