extends BaseInteractable

func interact():
	get_node("/root/Spatial/Televisionv04/Screen").visible = false
	get_node("/root/Spatial/Player").increment_progress()
	self.remove_from_group("interactable")
