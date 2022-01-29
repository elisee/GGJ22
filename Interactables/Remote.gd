extends BaseInteractable

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var television = get_tree().get_nodes_in_group("television")[0]

func interact():
	.interact()
	
	var tvLight = get_tree().find_node("Light TV")
	if tvLight != null:
		tvLight.visible = false
	
	television.get_node("Screen").visible = false
	player.increment_progress()
