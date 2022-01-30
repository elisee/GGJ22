extends Control

onready var buttonsCont = $ButtonsVBoxContainer

func _ready():
	$ButtonsVBoxContainer/PlayButton.grab_focus()

func _on_PlayButton_pressed():
	get_tree().change_scene("res://Cinematics/Intro.tscn")

func _on_CreditsButton_pressed():
	buttonsCont.visible = false
	$Credits.visible = true

func _on_BackButton_pressed():
	buttonsCont.visible = true
	$Credits.visible = false

func _on_QuitButton_pressed():
	get_tree().quit()
	
