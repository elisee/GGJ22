extends KinematicBody

var speed : float = 15
var acceleration : float = 10
var air_acceleration : float = 5
var gravity : float = 0.98
var max_terminal_velocity : float = 54
var jump_power : float = 15
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
signal canInteract(label)

var active_interactable: BaseInteractable = null

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/Camera
onready var animPlayer = $Character/AnimationPlayer
var landParticlesScene = preload("res://Player/LandParticles.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	animPlayer.get_animation("Idle").set_loop(true)
	animPlayer.get_animation("Idle2").set_loop(true)
	animPlayer.get_animation("Run").set_loop(true)

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

func incrementProgress():
	progress = clamp(progress + 10, 0, 100)
	emit_signal("progress", progress)

func _physics_process(delta):
	handle_look(delta)
	handle_movement(delta)
	
	check_interactable(delta)

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
	
	if Input.is_action_just_pressed("jump"):
		wantsToJumpTimer = 0.0
	else:
		wantsToJumpTimer += delta
		
	if wantsToJumpTimer < jump_flexibility_delay and fallingTimer < jump_flexibility_delay:
		y_velocity = jump_power
		fallingTimer = jump_flexibility_delay
		animPlayer.play("Jump")
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)
	y_velocity = velocity.y
	
	if is_on_floor():
		if fallingTimer == 0:
			animPlayer.play("Idle" if direction.length() == 0 else "Run")
		elif fallingTimer > 0.5:
			var instance = landParticlesScene.instance()
			get_tree().get_current_scene().add_child(instance)
			instance.translation = translation + velocity * 0.05
			instance.emitting = true
		
		fallingTimer = 0.0
	else:
		fallingTimer += delta

func check_interactable(delta):
	var interactables = get_tree().get_nodes_in_group("interactable")

	var new_interactable: BaseInteractable = null
	
	for node in interactables:
		var interactable := node as BaseInteractable
		if interactable.area.overlaps_body(self):
			new_interactable = interactable
			break

	if new_interactable != self.active_interactable:
		self.active_interactable = new_interactable
		var label = self.active_interactable.label if self.active_interactable != null else null
		emit_signal("canInteract", label)
	
	if Input.is_action_just_pressed("interact"):
		if self.active_interactable != null:
			self.active_interactable.interact()
