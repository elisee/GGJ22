extends BaseInteractable

func _ready():
	$Pivot.rotation_degrees.x = 103

func interact():
	.interact()
	
	$Pivot.rotation_degrees.x = 0
