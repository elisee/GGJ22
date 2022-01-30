extends CanvasLayer

func _on_Player_progress(newProgress, totalProgress):
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
