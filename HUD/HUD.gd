extends CanvasLayer

var initialized = false
var totalProgress = 0

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if initialized: return
	
	var interactables = get_tree().get_nodes_in_group("interactable")
	for node in interactables:
		var interactable := node as BaseInteractable
		if interactable.isProgress:
			totalProgress += 1

	$Root/ProgressBar/Label.text = "0 / " + str(totalProgress)

	initialized = true

func _on_Player_progress(newProgress):
	print(newProgress / totalProgress * 100)
	$Root/ProgressBar.value = 100.0 * newProgress / totalProgress
	$Root/ProgressBar/Label.text = str(newProgress) + " / " + str(totalProgress)


func _on_Player_setInteraction(label, can_interact):
	if label != "":
		$Root/InteractPanel.visible = true
		if can_interact:
			$Root/InteractPanel/InteractLabel.text = "(Press E) " + label
		else:
			$Root/InteractPanel/InteractLabel.text = label
	else:
		$Root/InteractPanel.visible = false
