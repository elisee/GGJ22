extends BaseInteractable

func interact():
	get_node("/root/Spatial/Televisionv04/Screen").visible = false
	get_node("/root/Spatial/Player").incrementProgress()
	self.remove_from_group("interactable")
