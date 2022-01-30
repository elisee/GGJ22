extends BaseInteractable

onready var plant = get_tree().get_nodes_in_group("plant")[0]

var active = false
var velocity = Vector3()

var speed : float = 4
var gravity : float = 0.98
var max_terminal_velocity : float = 54

var rot_prog = 0
var plant_grow = 0

func _ready():
	plant.translation.y -= 10

func interact():
	.interact()
	self.active = true
	$SoundPlayerWaterBottle.play()

func _physics_process(delta):
	if not self.active: return

	var body = self
	if body.is_on_floor():
		velocity.y = -0.01
	else:
		velocity.y = clamp(velocity.y - gravity, -max_terminal_velocity, max_terminal_velocity)

	if self.translation.y > 4:
		velocity.z = -speed
	else:
		velocity.z = 0
		if rot_prog < 16:
			rot_prog += 1
			body.rotate_z(-PI / 32)
		elif plant_grow < 10:
			plant_grow += 1
			plant.translation.y += 1

	velocity = body.move_and_slide(velocity, Vector3.UP)
