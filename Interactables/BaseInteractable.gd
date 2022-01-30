extends Spatial
class_name BaseInteractable

export var label = "LABEL"
export var conditionLabel = "CONDITION"
export var isProgress = true

onready var area: Area = $Area
onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready():
	self.add_to_group("interactable")

func can_interact():
	return true

func interact():
	# TODO: Override in child classes
	if isProgress: player.increment_progress()
	self.remove_from_group("interactable")
