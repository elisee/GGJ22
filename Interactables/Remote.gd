extends BaseInteractable

onready var television = get_tree().get_nodes_in_group("television")[0]

func interact():
	.interact()
	
	var tvLights = get_tree().get_nodes_in_group("lightTV")
	if tvLights.size() > 0: tvLights[0].visible = false

	$SoundPlayerUIRemote.play()
	$SoundPlayerTvPowerDown.play()
	$SoundPlayerUISuccess.play()
	
	television.get_node("Screen").visible = false
	television.get_node("SoundPlayerStaticLoop").playing = false
	television.get_node("SoundPlayerTvBroadcast").playing = false
