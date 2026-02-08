extends Node2D

var mao_inimigo: Array
var mao_jogador: Array

func setup_jogador() -> void:
	$Jogador.setup()

func setup_inimigo() -> void:
	$Inimigo.setup(1)

func setup_jogo() -> void:
	setup_jogador()
	setup_inimigo()
	jogo()

func _ready() -> void:
	setup_jogo()

func jogo() -> void:
	# inimigo escolhe a mão
	mao_inimigo = $Inimigo.decidir_mao()
	
	# jogador pode usar powerup
	# jogador pode descartar cartas
	
	# jogador pode usar powerup
	# jogador escolhe mão
	# compara mãos e decide o que acontece
