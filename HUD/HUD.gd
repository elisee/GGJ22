extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_progress(newProgress):
	$Root/ProgressBar.value = newProgress


func _on_Player_canInteract(label):
	if label != null:
		$Root/InteractPanel.visible = true
		$Root/InteractPanel/InteractLabel.text = "(Press E) " + label
	else:
		$Root/InteractPanel.visible = false
