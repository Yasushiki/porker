extends Node2D

var baralho: Baralho = Baralho.new()

func comecar_jogo() -> void:
	baralho.criar_baralho() # cria a instância do baralho
	$Mao.set_baralho(baralho) # compõe a instância da mão com a instância do baralho
	$Mao.criar_mao()
	

func _ready() -> void:
	comecar_jogo()

func _on_button_pressed() -> void:
	$Mao.descartar_selecionadas()
