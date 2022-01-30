extends Spatial

export var respawn = Vector3()

onready var player = get_tree().get_nodes_in_group("player")[0] as KinematicBody

func _ready():
	pass

func _process(delta):
	if $Area.overlaps_body(player):
		player.translation = respawn
