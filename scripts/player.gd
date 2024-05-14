extends CharacterBody2D

class_name Player


const SPEED = 200.0
const JUMP_VELOCITY = -400.0
const FORCE_JUMP = 400

enum dash_state {CAN_DASH, CHARGING, DASHED}
var dash := dash_state.CAN_DASH
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var speed := Vector2.ZERO
var accel := Vector2.ZERO


func force_dash():
	var dir := (get_global_mouse_position() - position).normalized()
	velocity = dir * FORCE_JUMP

func manage_dash():
	if Input.is_action_just_pressed("dash") and dash == dash_state.CAN_DASH:
		dash = dash_state.CHARGING
		Engine.time_scale = .2
	if Input.is_action_just_released("dash") and dash == dash_state.CHARGING:
		force_dash()
		Engine.time_scale = 1
		dash = dash_state.DASHED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		dash = dash_state.CAN_DASH

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle force jump
	manage_dash()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if is_on_floor:
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			

	move_and_slide()
	
