extends Node2D

func _ready():
	Musica.play_menu_music()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/menu.tscn")

func _on_ngp_pressed() -> void:
	Global.nivel += 1
	Musica.stop_music()
	get_tree().change_scene_to_file("res://scene/mesa.tscn")
