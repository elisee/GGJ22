extends BaseInteractable

func interact():
	get_node("/root/Spatial/Televisionv04/Screen").visible = false
	self.remove_from_group("interactable")
