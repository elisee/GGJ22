extends BaseInteractable

func interact():
	.interact()
	
	self.rotation_degrees.z = 0
	$SoundPlayerFrameFix.play()
