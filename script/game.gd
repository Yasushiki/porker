extends Node2D

var baralho: Baralho = Baralho.new()

func comecar_jogo():
	baralho.criar_baralho() # cria a instância do baralho
	$Mao.set_baralho(baralho) # compõe a instância da mão com a instância do baralho
	$Mao.criar_mao()
	

func _ready() -> void:
	comecar_jogo()
