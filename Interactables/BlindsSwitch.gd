extends BaseInteractable

onready var blinds = get_tree().get_nodes_in_group("blinds")[0]

var active = false

func interact():
	.interact()
	
	$Switch_Button.rotation_degrees.x = 20
	self.active = true
	$SoundPlayerUIBlindsSwitch.play()
	$SoundPlayerBlindsOpen.play()
	$SoundPlayerUISuccess.play()

func _process(delta):
	if not self.active:
		return
	
	var blind1 = blinds.get_node("Blind_01") as Spatial
	var blind2 = blinds.get_node("Blind_02") as Spatial
	
	blind1.translation.y = lerp(blind1.translation.y, 13, delta * 0.7)
	blind2.translation.y = lerp(blind2.translation.y, 13.3, delta * 1.2)
