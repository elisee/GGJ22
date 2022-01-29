extends BaseInteractable

onready var player = get_tree().get_nodes_in_group("player")[0]

func interact():
	.interact()
	$Particles.emitting = true
	player.increment_progress()
