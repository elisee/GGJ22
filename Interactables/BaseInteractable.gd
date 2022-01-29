extends Node
class_name BaseInteractable

export var label = "LABEL"
export var conditionLabel = "CONDITION"

onready var area: Area = $Area

func _ready():
	self.add_to_group("interactable")

func can_interact():
	return true

func interact():
	# TODO: Override in child classes
	self.remove_from_group("interactable")
