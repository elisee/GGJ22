extends KinematicBody

var speed : float = 20
var acceleration : float = 15
var air_acceleration : float = 5
var gravity : float = 0.98
var max_terminal_velocity : float = 54
var jump_power : float = 25
var jump_flexibility_delay : float = 0.15

var mouse_sensitivity = 0.3
var look_speed = 200
var min_pitch : float = -70
var max_pitch : float = 70

var velocity : Vector3
var y_velocity : float

var fallingTimer = 0.0
var wantsToJumpTimer = jump_flexibility_delay

var progress = 0;
signal progress(newProgress)

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/CameraBoom/Camera

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:		
		if event is InputEventMouseMotion:
			rotation_degrees.y -= event.relative.x * mouse_sensitivity
			camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
			camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if (Input.is_action_just_pressed("jump")):
		progress = clamp(progress + 10, 0, 100)
		emit_signal("progress", progress)

func _physics_process(delta):
	handle_look(delta)
	handle_movement(delta)

func handle_look(delta):
	if Input.is_action_pressed("look_up"):
		camera_pivot.rotation_degrees.x -= delta * look_speed
	if Input.is_action_pressed("look_down"):
		camera_pivot.rotation_degrees.x += delta * look_speed
	camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)

	if Input.is_action_pressed("look_left"):
		rotation_degrees.y += delta * look_speed
	if Input.is_action_pressed("look_right"):
		rotation_degrees.y -= delta * look_speed

func handle_movement(delta):
	var direction = Vector3()
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	
	if Input.is_action_pressed("move_backward"):
		direction += transform.basis.z
		
	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if is_on_floor():
		fallingTimer = 0.0
	else:
		fallingTimer += delta
	
	if Input.is_action_just_pressed("jump"):
		wantsToJumpTimer = 0.0
	else:
		wantsToJumpTimer += delta
		
	if wantsToJumpTimer < jump_flexibility_delay and fallingTimer < jump_flexibility_delay:
		y_velocity = jump_power
		fallingTimer = jump_flexibility_delay
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)
	y_velocity = velocity.y
