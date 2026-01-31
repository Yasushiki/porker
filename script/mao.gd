class_name Mao extends Node2D

var baralho: Baralho
var mao: Array[Vector2] = []

func set_baralho(ref_baralho: Baralho):
	baralho = ref_baralho

func ordenar_mao():
	mao.sort_custom(func(a: Vector2, b: Vector2): return a > b)

func renderizar_mao():
	$Carta0.atualizar_valor(mao[0])
	$Carta1.atualizar_valor(mao[1])
	$Carta2.atualizar_valor(mao[2])
	$Carta3.atualizar_valor(mao[3])
	$Carta4.atualizar_valor(mao[4])

func criar_mao():
	for i in range(5):
		var carta: Vector2 = baralho.monte.pick_random()
		baralho.monte.erase(carta)
		baralho.descarte.append(carta)
		mao.append(carta)
	ordenar_mao()
	renderizar_mao()
