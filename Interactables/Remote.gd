extends BaseInteractable

func interact():
	.interact()
	get_node("/root/Spatial/Televisionv04/Screen").visible = false
	get_node("/root/Spatial/Player").increment_progress()
