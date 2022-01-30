extends BaseInteractable

func interact():
	.interact()
	$Particles.emitting = true
	$SoundPlayerUICoffeeSwitch.play()
	$SoundPlayerCoffeeMachineOn.play()
	$SoundPlayerUISuccess.play()
