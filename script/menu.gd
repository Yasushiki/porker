extends Node2D

func _ready():
	Musica.play_menu_music()
	if OS.get_name() == "Web":
		$Sair.visible = false
		$Sair.disabled = true

func _on_creditos_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/creditos.tscn")


func _on_ajuda_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/ajuda.tscn")


func _on_comecar_pressed() -> void:
	Global.nivel = 1
	Musica.stop_music()
	get_tree().change_scene_to_file("res://scene/mesa.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()
