class_name Jogador extends Node2D

var baralho: Baralho = Baralho.new()


var vida: int
var dinheiro: int

func setup() -> void:
	$Mao.set_baralho(baralho) # compõe a instância da mão com a instância do baralho
	$Mao.criar_mao()

func _on_button_pressed() -> void:
	$Mao.descartar_selecionadas()
