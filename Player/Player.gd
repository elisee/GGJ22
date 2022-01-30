extends KinematicBody

var speed : float = 15
var acceleration : float = 10
var decceleration : float = 20
var air_acceleration : float = 5
var gravity : float = 0.98
var max_terminal_velocity : float = 54
var jump_power : float = 19
var jump_flexibility_delay : float = 0.15

var mouse_sensitivity = 0.3
var look_speed = 200
var min_pitch : float = -70
var max_pitch : float = 70

var velocity : Vector3
var y_velocity : float

var fallingTimer = 0.0
var wantsToJumpTimer = jump_flexibility_delay

var initialized = false
var progress = 0.0
var totalProgress = 0.0
var musicLevel = 0
signal progress(newProgress, totalProgress)
signal setInteraction(label)

var active_interactable: BaseInteractable = null

var item: String = ""

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/Camera
onready var animPlayer = $Character/AnimationPlayer

var landParticlesScene = preload("res://Player/LandParticles.tscn")

var musics = [
	preload("res://Sounds/Music/CheeseMouse01.wav"),
	preload("res://Sounds/Music/CheeseMouse02.wav"),
	preload("res://Sounds/Music/CheeseMouse03.wav"),
	preload("res://Sounds/Music/CheeseMouse04.wav")
]

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
	if not initialized:
		var interactables = get_tree().get_nodes_in_group("interactable")
		for node in interactables:
			var interactable := node as BaseInteractable
			if interactable.isProgress:
				totalProgress += 1.0

		emit_signal("progress", progress, totalProgress)
		initialized = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

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
	
	var accel = 0.0
	if is_on_floor():
		accel = decceleration if direction.length() == 0 else acceleration
	else:
		accel = air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
	
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
	
	if Input.is_action_just_pressed("jump"):
		wantsToJumpTimer = 0.0
		$SoundPlayerWalk.stop()
		$SoundPlayerJumpVO.play_random()
		$SoundPlayerJump.play_random()
	else:
		wantsToJumpTimer += delta
		
	if wantsToJumpTimer < jump_flexibility_delay and fallingTimer < jump_flexibility_delay:
		y_velocity = jump_power
		fallingTimer = jump_flexibility_delay
		animPlayer.play("Jump")
	
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP, true)
	y_velocity = velocity.y
	
	if is_on_floor():
		if fallingTimer == 0:
			if direction.length() == 0:
				animPlayer.play("Idle")
				$SoundPlayerWalk.stop()
			else:
				animPlayer.play("Run", -1, 1.6)
				if not $SoundPlayerWalk.is_playing():	
					$SoundPlayerWalk.play()
		elif fallingTimer > 0.5:
			var instance = landParticlesScene.instance()
			get_tree().get_current_scene().add_child(instance)
			instance.translation = translation + velocity * 0.05
			instance.emitting = true
			$SoundPlayerLand.play_random()
		
		fallingTimer = 0.0
	else:
		fallingTimer += delta
		$SoundPlayerWalk.stop()

func check_interactable(delta):
	var interactables = get_tree().get_nodes_in_group("interactable")

	var new_interactable: BaseInteractable = null
	
	for node in interactables:
		var interactable := node as BaseInteractable
		if interactable.area.overlaps_body(self):
			new_interactable = interactable
			break

	var can_interact = new_interactable != null and new_interactable.can_interact()

	if new_interactable != self.active_interactable:
		self.active_interactable = new_interactable
		if self.active_interactable != null:
			var label = self.active_interactable.label if can_interact else self.active_interactable.conditionLabel
			emit_signal("setInteraction", label, can_interact)
		else:
			emit_signal("setInteraction", "", false)
	
	if Input.is_action_just_pressed("interact") and can_interact:
		self.active_interactable.interact()

func set_item(item: String):
	if item != "":
		assert(self.item == "")
		self.item = item
		# TODO: Add item above player
	else:
		self.item = ""

func get_item():
	return self.item

func increment_progress():
	progress += 1.0
	
	var newMusicLevel = 0
	if progress / totalProgress >= 1.0:
		newMusicLevel = 3
	elif progress / totalProgress >= 0.66:
		newMusicLevel = 2
	elif progress / totalProgress >= 0.33:
		newMusicLevel = 1
	
	if musicLevel != newMusicLevel:
		musicLevel = newMusicLevel
		var playbackPos = $SoundPlayerMusic.get_playback_position()
		$SoundPlayerMusic.stream = musics[musicLevel]
		$SoundPlayerMusic.play(playbackPos)
	
	emit_signal("progress", progress, totalProgress)
