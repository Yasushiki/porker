extends Node2D

var mao_inimigo: Dictionary
var preco_inimigo: int
var mao_jogador: Dictionary
var preco_jogador: int

enum Estado {
	SETUP,
	TURNO_INIMIGO,
	ESPERAR_JOGADOR,
	TURNO_JOGADOR,
	BATALHA,
	GANHAR,
	PERDER
}

var estado: Estado = Estado.SETUP

func _ready() -> void:
	$Jogador.connect("jogar", _on_jogar.bind($Jogador))
	mudar_estado(Estado.SETUP)

func mudar_estado(e):
	estado = e
	
	match estado:
		# Faz o setup do jogo
		Estado.SETUP:
			setup_jogo()
		
		# O inimigo escolhe a mão dele
		Estado.TURNO_INIMIGO:
			$Inimigo/Mao.completar_mao()
			turno_inimigo()
		
		# Espera o jogador fazer alguma coisa
		Estado.ESPERAR_JOGADOR:
			$Jogador/Mao.completar_mao()
			checar_jogador()
		
		# Compara as mãos do jogador e do inimgo
		# começa um novo round (TURNO_INIMIGO) ou acaba (FIM)
		Estado.BATALHA:
			comparar_maos()
		
		# Acaba o jogo e mostra a tela de vitória
		Estado.GANHAR:
			get_tree().change_scene_to_file("res://scene/vitoria.tscn")
		
		# Acaba o jogo e mostra a tela de derrota
		Estado.PERDER:
			get_tree().change_scene_to_file("res://scene/derrota.tscn")


### SETUP ###
func setup_jogador() -> void:
	$Jogador.setup()
func setup_inimigo() -> void:
	$Inimigo.setup(1)
func setup_jogo() -> void:
	setup_jogador()
	setup_inimigo()
	mudar_estado(Estado.TURNO_INIMIGO)
### Setup ###

### TURNO INIMIGO ###
func turno_inimigo():
	$Inimigo.decidir_mao()
	mao_inimigo = $"Inimigo/Mao".info_mao
	preco_inimigo = $"Inimigo/Mao".custo
	mudar_estado(Estado.ESPERAR_JOGADOR)
### Turno inimigo ###

### ESPERAR JOGADOR ###
func checar_jogador():
	if $Jogador.vida == 0 or $Jogador.baralho_vazio():
		print($Jogador.vida)
		print($Jogador.baralho_vazio())
		mudar_estado(Estado.PERDER)

func _on_jogar(_filha):
	mao_jogador = $"Jogador/Mao".info_mao
	preco_jogador = $"Jogador/Mao".custo
	
	$Inimigo.jogar_mao()
	
	mudar_estado(Estado.BATALHA)



### Esperar jogador ###

### BATALHA ###
func comparar_maos():
	var dano = 0
	
	# Se o inimigo não conseguir jogar nenhuma carta
	if mao_inimigo == {}:
		mudar_estado(Estado.GANHAR)
		return
	
	# Verifica se o jogador jogou exódia e o inimigo jogou cenoura
	if mao_jogador.tipo == 11:
		if mao_inimigo.cenoura:
			perder_rodada(4)
			return
	# Verifica se o inimigo jogou exódia e o jogador jogou cenoura
	if mao_inimigo.tipo == 11:
		if mao_jogador.cenoura:
			ganhar_rodada(4)
			return
	
	# Verifica qual mão é mais poderosa
	if mao_jogador.tipo > mao_inimigo.tipo:
		@warning_ignore("integer_division")
		dano = int(mao_jogador.tipo - mao_inimigo.tipo)/3 + 1
		ganhar_rodada(dano)
		return
	if mao_jogador.tipo < mao_inimigo.tipo:
		@warning_ignore("integer_division")
		dano = int(mao_inimigo.tipo - mao_jogador.tipo)/3 + 1
		perder_rodada(dano)
		return
	
	# Se for o mesmo tipo de mão, verifica qual o maior ranque
	if mao_jogador.carta_alta[1] > mao_inimigo.carta_alta[1]:
		ganhar_rodada(1)
		return
	if mao_jogador.carta_alta[1] < mao_inimigo.carta_alta[1]:
		perder_rodada(1)
		return
		
	# Se for o mesmo número, verifica qual o maior naipe
	if mao_jogador.carta_alta[0] > mao_inimigo.carta_alta[0]:
		ganhar_rodada(1)
		return
	if mao_jogador.carta_alta[0] < mao_inimigo.carta_alta[0]:
		perder_rodada(1)
		return
	
	# Se nada acontecer, é empate
	empate()
func empate():
	$Jogador.atualizar_dinheiro(-preco_jogador)
	$Inimigo.atualizar_dinheiro(-preco_inimigo)
	
	if $Inimigo.dinheiro == 0:
		mudar_estado(Estado.GANHAR)
	if $Jogador.dinheiro == 0:
		mudar_estado(Estado.PERDER)
	
	$Label.text = "Empate"
	mudar_estado(Estado.TURNO_INIMIGO)
	
func ganhar_rodada(dano: int):
	# O jogador ganha metade do que o inimigo gastou com a mão
	$Jogador.atualizar_dinheiro(preco_jogador-preco_inimigo)
#	@warning_ignore("integer_division")
#	$Jogador.atualizar_dinheiro(preco_inimigo)
	
	$Inimigo.atualizar_dinheiro(-preco_inimigo)
	$Inimigo.atualizar_vida(-dano)
	
	if $Inimigo.vida <= 0:
		mudar_estado(Estado.GANHAR)
		return
	
	$Label.text = "Ganhou"
	mudar_estado(Estado.TURNO_INIMIGO)
func perder_rodada(dano: int):
	# O jogador ganha metade do que o inimigo gastou com a mão
	$Inimigo.atualizar_dinheiro(-preco_inimigo)
	@warning_ignore("integer_division")
	$Inimigo.atualizar_dinheiro(int(preco_jogador/2))
	
	$Jogador.atualizar_dinheiro(-preco_jogador)
	$Jogador.atualizar_vida(-dano)
	
	if $Jogador.vida <= 0:
		mudar_estado(Estado.PERDER)
		return
	
	$Label.text = "Perdeu"
	mudar_estado(Estado.TURNO_INIMIGO)
### Batalha ###
