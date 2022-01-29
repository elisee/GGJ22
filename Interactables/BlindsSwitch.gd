extends BaseInteractable

onready var player = get_tree().get_nodes_in_group("player")[0]
onready var blinds = get_tree().get_nodes_in_group("blinds")[0]

func interact():
	.interact()
	
	$Switch_Button.rotation_degrees.x = 20
	
	# blinds.get_node("Screen").visible = false
	player.increment_progress()
