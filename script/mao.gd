class_name Mao extends Node

var baralho: Baralho
var mao: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i(), Vector2i()]

var custo: int

var submao: Array[Vector2i]

func _ready() -> void:
		
	for filha in get_children():
		if filha.has_signal("foi_selecionada"):
			filha.connect("foi_selecionada", _on_foi_selecionado.bind(filha))
			filha.connect("foi_desselecionada", _on_foi_desselecionado.bind(filha))

func _on_foi_selecionado(naipe, ranque, _filha):
	submao.append(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	var r = verificar_mao()
	print(r)

func _on_foi_desselecionado(naipe, ranque, _filha):
	submao.erase(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	if not submao.is_empty():
		var r = verificar_mao()
		print(r)

func set_baralho(ref_baralho: Baralho) -> void:
	baralho = ref_baralho
	
func ordenar_mao() -> void:
	mao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	mao.sort_custom(func(_a: Vector2i, b: Vector2i): return b == Vector2i())
	
func renderizar_mao(inimigo: bool = false) -> void:
	if not inimigo:
		var cartas: Array = get_children().filter(func(a): return a is Node2D)
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
	var cartas: Array = get_children().filter(func(a): return a is Node2D)
	var c: int = 0
	
	for i in range(cartas.size()):
		if cartas[i].selecionado:
			cartas[i].desselecionar()
			mao[i] = Vector2i()
			c += 1
	
	for i in range(c):
		comprar_carta()
	
	submao.clear()
	ordenar_mao()
	renderizar_mao(inimigo)


func verificar_mao() -> Array:
	"""
	Retorna um Array com 4 valores, sendo eles:
	- Qual a mão
	- Naipe da maior carta
	- Ranque da maior carta
	- Possui cenoura
	"""
	
	if submao.size() == 1:
		return [0, submao[0][0], submao[0][1], analisar_cenoura()]
	else: # mao.size() == 2
		var carta = analisar_par()
		var num_mao = 1
		if carta == [-2, -2]:
			carta = analisar_carta_alta()
			num_mao = 0
		
		return [num_mao, carta[0], carta[1], analisar_cenoura()]

func analisar_cenoura() -> int:
	# retorna 1 caso tenha uma cenoura na mão, retorna 0 caso contrário
	return 1 if submao[0][0] == -1 else 0

func analisar_carta_alta() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = [-2, -2]
	
	# passa por todas as cartas e pega a maior carta na mão
	for carta in submao:
		if carta[1] > r[1]:
			r = [carta[0], carta[1]]
	
	return r

func analisar_par() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = [-2, -2]
	
	for i in range(submao.size() - 1):
		for j in range(i + 1, submao.size()):
			if submao[i][1] == submao[j][1]:
				r = [submao[i][0], submao[i][1]] if submao[i].x > submao[j].x \
												 else [submao[j][0], submao[j][1]]
				break
	
	return r
