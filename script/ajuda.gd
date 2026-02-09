extends Node2D

var last: int = 20

func _ready() -> void:
	mostrar(0)

func _on_direita_pressed() -> void:
	Global.ajuda += 1
	mostrar(Global.ajuda)

func _on_esquerda_pressed() -> void:
	Global.ajuda -= 1
	mostrar(Global.ajuda)

func mostrar(ajuda: int):
	var l = get_node("Label%d" % ajuda)
	l.visible = true
	
	if ajuda == 0:
		get_node("Label1").visible = false
		$Esquerda.visible = false
		$Esquerda.disabled = true
		$Direita.visible = true
		$Direita.disabled = false
	elif ajuda == last:
		get_node("Label%d" % (last - 1)).visible = false
		$Esquerda.visible = true
		$Esquerda.disabled = false
		$Direita.visible = false
		$Direita.disabled = true
	else:
		get_node("Label%d" % (ajuda - 1)).visible = false
		get_node("Label%d" % (ajuda + 1)).visible = false
		$Esquerda.visible = true
		$Esquerda.disabled = false
		$Direita.visible = true
		$Direita.disabled = false


func _on_back_pressed() -> void:
	Global.ajuda = 0
	get_tree().change_scene_to_file("res://scene/menu.tscn")
