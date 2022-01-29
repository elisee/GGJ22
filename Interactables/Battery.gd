extends BaseInteractable

onready var player = get_tree().get_nodes_in_group("player")[0]

func can_interact():
	if player.get_item() != "": return false
	return true

func interact():
	.interact()
	player.set_item("Battery")
	self.queue_free()
