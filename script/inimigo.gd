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
	#baralho.adicionar_carta(Baralho.CENOURA)
	
	match n:
		pass

func setup_parametros(n: int):
	@warning_ignore("integer_division")
	vida = floor(5 + n/2)
	dinheiro = 80 + 20*n
	
	$Vida.text = "❤️".repeat(vida)
	
	if OS.is_debug_build():
		$Dinheiro.text = str(dinheiro)

func setup_mao():
	$Mao.set_baralho(baralho)
	$Mao.criar_mao()
#### Setup ####

#### Jogo ####
func decidir_mao() -> void:
	# Confere todas as mãos possíveis
	$Mao.submao = $Mao.mao.duplicate()
	var jogada
	
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
		jogada = anal[i].call($Mao.submao)
		if jogada.e:
			jogada.extra = []
			jogada["cenoura"] = Verificador.analisar_cenoura($Mao.submao)
			
			var custo = Verificador.calcular_custo(jogada)
			
			if dinheiro >= custo:
				$Mao.info_mao = jogada
				$Mao.custo = custo
				
				# se o inimigo consegue jogar uma cenoura, ele joga
				if dinheiro+1 >= custo and jogada.cenoura:
					jogada.extra.append(Baralho.CENOURA)
				
				if OS.is_debug_build():
					$Label.text = str($Mao.info_mao)
					$Label2.text = str($Mao.custo)
				return
	
	# Se não tiver dinheiro pra jogar nenhuma carta, retorna nada
	$Mao.info_mao = {}
	if OS.is_debug_build():
		$Label.text = str($Mao.info_mao)

func jogar_mao() -> void:
	
	$Mao.jogar_selecionadas($Mao.info_mao.cartas)
	$Mao.jogar_selecionadas($Mao.info_mao.extra)
	
#	if not baralho.has(Baralho.CENOURA):
#		baralho.adicionar_carta(Baralho.CENOURA)
#### Jogo #####

func atualizar_vida(v: int):
	vida += v
	$Vida.text = "❤️".repeat(vida)

func atualizar_dinheiro(d: int):
	dinheiro += d
	if OS.is_debug_build():
		$Dinheiro.text = str(dinheiro)
