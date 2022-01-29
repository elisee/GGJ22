extends BaseInteractable

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var television = get_tree().get_nodes_in_group("television")[0]

func interact():
	.interact()
	television.get_node("Screen").visible = false
	player.increment_progress()
