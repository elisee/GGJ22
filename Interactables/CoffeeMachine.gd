extends BaseInteractable

func interact():
	.interact()
	$Particles.emitting = true
	get_node("/root/Spatial/Player").incrementProgress()
