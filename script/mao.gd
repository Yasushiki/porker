class_name Mao extends Node

var baralho: Baralho
var mao: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i(), Vector2i()]
var custo: int

func set_baralho(ref_baralho: Baralho) -> void:
	baralho = ref_baralho
	
func ordenar_mao() -> void:
	mao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	mao.sort_custom(func(_a: Vector2i, b: Vector2i): return b == Vector2i())
	
func renderizar_mao(inimigo: bool = false) -> void:
	if not inimigo:
		var cartas: Array = get_children()
		var i: int = 0
		for carta in cartas:
			carta.selecionar_sprite(mao[i])
			i += 1
	else:
		pass
	
func comprar_carta() -> void:
	if not baralho.monte.is_empty():
		var carta: Vector2i = baralho.monte.pick_random()
		
		baralho.descartar_carta(carta)
		for i in range(5):
			if mao[i] == Vector2i():
				mao[i] = carta
				break
	
func criar_mao(inimigo: bool = false) -> void:
	for i in range(5):
		comprar_carta()
	ordenar_mao()
	renderizar_mao(inimigo)
	
func descartar_selecionadas(inimigo: bool = false) -> void:
	var cartas: Array = get_children()
	var c: int = 0
	
	for i in range(cartas.size()):
		if cartas[i].selecionado:
			cartas[i].desselecionar()
			mao[i] = Vector2i()
			c += 1
	
	for i in range(c):
		comprar_carta()
	
	ordenar_mao()
	renderizar_mao(inimigo)
	

# confere qual a mão vigente dentre as cartas selecionadas
func conferir_mao():
	pass
