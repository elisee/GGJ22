extends BaseInteractable

func can_interact():
	return get_node("/root/Spatial/Player").get_item() == "Battery"

func interact():
	.interact()
	print("VACUUM!")
	
	get_node("/root/Spatial/Player").increment_progress()
