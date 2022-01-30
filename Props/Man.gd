extends Spatial

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.get_animation("Idle_Human").set_loop(true)
