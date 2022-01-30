extends Control

func _ready():
	$RootVBoxContainer/ButtonsVBoxContainer/PlayButton.grab_focus()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Dev/Mord/map2.tscn")

func _on_QuitButton_pressed():
	get_tree().quit()
