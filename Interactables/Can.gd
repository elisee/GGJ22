extends BaseInteractable

var active = false
var velocity = Vector3()

var speed : float = 3
var gravity : float = 0.98
var max_terminal_velocity : float = 54

func interact():
	.interact()
	self.active = true

func _physics_process(delta):
	if not self.active: return

	var body = self
	if body.is_on_floor():
		velocity.y = -0.01
	else:
		velocity.y = clamp(velocity.y - gravity, -max_terminal_velocity, max_terminal_velocity)

	if self.translation.y > 8:
		velocity.x = speed
	else:
		velocity.x = 0

	velocity = body.move_and_slide(velocity, Vector3.UP)
