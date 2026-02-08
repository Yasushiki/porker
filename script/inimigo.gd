class_name Inimigo extends Node

var baralho: Baralho = Baralho.new()
var vida: int
var dinheiro: int

#### SETUP ####
func setup(n: int):
	setup_baralho(n)
	setup_parametros(n)
	setup_mao()

func setup_baralho(n: int):
	match n:
		pass

func setup_parametros(n: int):
	match n:
		1:
			vida = 10
			dinheiro = 30
	
	$Vida.text = "❤️".repeat(vida)
	
	if OS.is_debug_build():
		$Dinheiro.text = str(dinheiro)

func setup_mao():
	$Mao.set_baralho(baralho)
	$Mao.criar_mao()
#### Setup ####

#### Jogo ####
func decidir_mao() -> Array:
	# Confere todas as mãos possíveis
	$Mao.submao = $Mao.mao
	var carta
	
	var anal = [
		Verificador.analisar_exodia,
		Verificador.analisar_quina,
		Verificador.analisar_quadra,
		Verificador.analisar_familia_completa,
		Verificador.analisar_full_house,
		Verificador.analisar_flush,
		Verificador.analisar_sequencia,
		Verificador.analisar_familia,
		Verificador.analisar_trinca,
		Verificador.analisar_dois_pares,
		Verificador.analisar_par, 
		Verificador.analisar_carta_alta
	]
	
	# Joga a maior carta que ele tem dinheiro pra jogar
	for i in range(anal.size()):
		carta = anal[i].call($Mao.submao)
		if carta != Global.DEFAULT:
			Verificador.calcular_custo($Mao.info_mao)
			if dinheiro >= $Mao.custo:
				return carta
	
	# Se não tiver dinheiro pra jogar nenhuma carta, retorna nada
	return []
#### Jogo #####

func atualizar_vida(v: int):
	vida = v
	$Vida.text = "❤️".repeat(vida)

func atualizar_dinheiro(d: int):
	dinheiro = d
	if OS.is_debug_build():
		$Dinheiro.text = dinheiro
