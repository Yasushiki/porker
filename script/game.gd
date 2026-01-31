extends Node2D

var baralho_jogador: Baralho = Baralho.new()

func setup_jogador() -> void:
	$Mao_Jogador.set_baralho(baralho_jogador) # compõe a instância da mão com a instância do baralho
	$Mao_Jogador.criar_mao()

func comecar_jogo() -> void:
	pass

func _ready() -> void:
	comecar_jogo()

func _on_button_pressed() -> void:
	$Mao.descartar_selecionadas()
