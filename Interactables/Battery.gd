extends BaseInteractable

func can_interact():
	if player.get_item() != "": return false
	return true

func interact():
	.interact()
	player.set_item("Battery")
	self.queue_free()
