extends Control

func _ready():
	yield(get_tree().create_timer(3.0), "timeout")
	get_tree().change_scene("res://Dev/Mord/map2.tscn")
