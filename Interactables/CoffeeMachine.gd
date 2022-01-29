extends BaseInteractable

func interact():
	.interact()
	$Particles.emitting = true
	get_node("/root/Spatial/Player").increment_progress()
