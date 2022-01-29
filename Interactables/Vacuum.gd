extends BaseInteractable

func interact():
	.interact()
	print("VACUUM!")
	
	get_node("/root/Spatial/Player").incrementProgress()
