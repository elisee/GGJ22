extends BaseInteractable

func can_interact():
	if get_node("/root/Spatial/Player").get_item() != "": return false
	return true

func interact():
	.interact()
	get_node("/root/Spatial/Player").set_item("Battery")
	self.queue_free()
