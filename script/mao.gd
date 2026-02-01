class_name Mao extends Node

var baralho: Baralho
var mao: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i(), Vector2i()]

var custo: int
var poder: int

var submao: Array[Vector2i]

const DEFAULT = [-2, -2]

func _ready() -> void:
		
	for filha in get_children():
		if filha.has_signal("foi_selecionada"):
			filha.connect("foi_selecionada", _on_foi_selecionado.bind(filha))
			filha.connect("foi_desselecionada", _on_foi_desselecionado.bind(filha))

func _on_foi_selecionado(naipe, ranque, _filha):
	submao.append(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	var r = verificar_mao()
	imprimir_mao(r)

func _on_foi_desselecionado(naipe, ranque, _filha):
	submao.erase(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	if not submao.is_empty():
		var r = verificar_mao()
		imprimir_mao(r)

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

func imprimir_mao(m: Array) -> void:
	match m[0]:
		0:
			print("Carta alta - Maior carta: %d%d" % [m[1], m[2]])
		1:
			print("Par - Maior carta: %d%d" % [m[1], m[2]])
		2:
			print("Dois Pares - Maior carta: %d%d" % [m[1], m[2]])
		3:
			print("Trinca - Maior carta: %d%d" % [m[1], m[2]])
		4:
			print("Família - Maior carta: %d%d" % [m[1], m[2]])
		5: 
			print("Sequência - Maior carta: %d%d" % [m[1], m[2]])
		6:
			print("Flush - Maior carta: %d%d" % [m[1], m[2]])
		7:
			print("Full House - Maior carta: %d%d" % [m[1], m[2]])
		8:
			print("Família Completa - Maior carta: %d%d" % [m[1], m[2]])
		9:
			print("Quadra - Maior carta: %d%d" % [m[1], m[2]])
		10:
			print("Quina - Maior carta: %d%d" % [m[1], m[2]])
		11:
			print("Exodia - Maior carta: %d%d" % [m[1], m[2]])

func verificar_mao() -> Array:
	var carta
	var num_mao
	"""
	Retorna um Array com 4 valores, sendo eles:
	- Qual a mão
	- Naipe da maior carta
	- Ranque da maior carta
	- Possui cenoura
	"""
	
	if submao.size() == 1:
		return [0, submao[0][0], submao[0][1], analisar_cenoura()]
		
	elif submao.size() == 2:
		var anal = [
			analisar_par,
			analisar_carta_alta
		]
		var val = [1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call()
			if carta != DEFAULT:
				num_mao = val[i]
				break
		
		return [num_mao, carta[0], carta[1], analisar_cenoura()]
	
	elif submao.size() == 3:
		var anal = [
			analisar_familia,
			analisar_trinca,
			analisar_par, 
			analisar_carta_alta
		]
		
		var val = [4, 3, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call()
			if carta != DEFAULT:
				num_mao = val[i]
				break
			
		return [num_mao, carta[0], carta[1], analisar_cenoura()]

	elif submao.size() == 4:
		var anal = [
			analisar_quadra,
			analisar_sequencia,
			analisar_familia,
			analisar_trinca,
			analisar_dois_pares,
			analisar_par, 
			analisar_carta_alta
		]
		
		var val = [9, 5, 4, 3, 2, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call()
			if carta != DEFAULT:
				num_mao = val[i]
				break
				
		return [num_mao, carta[0], carta[1], analisar_cenoura()]
		
	else:
		var anal = [
			analisar_exodia,
			analisar_quina,
			analisar_quadra,
			analisar_familia_completa,
			analisar_full_house,
			analisar_flush,
			analisar_sequencia,
			analisar_familia,
			analisar_trinca,
			analisar_dois_pares,
			analisar_par, 
			analisar_carta_alta
		]
		
		var val = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
		
		for i in range(anal.size()):
			carta = anal[i].call()
			if carta != DEFAULT:
				num_mao = val[i]
				break
				
		return [num_mao, carta[0], carta[1], analisar_cenoura()]

func analisar_cenoura() -> int:
	# retorna 1 caso tenha uma cenoura na mão, retorna 0 caso contrário
	return 1 if submao[0][0] == -1 else 0

func analisar_carta_alta() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	
	# passa por todas as cartas e pega a maior carta na mão
	for carta in submao:
		if carta[1] > r[1]:
			r = [carta[0], carta[1]]
	
	return r

func analisar_par(num: int = 0) -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	
	for i in range(submao.size() - 1):
		# Se a carta passa por parâmetro for a mesma que está sendo analisada, ele pula a carta
		if submao[i][1] == num:
			continue
		for j in range(i + 1, submao.size()):
			if submao[i][1] == submao[j][1]:
				r = [submao[i][0], submao[i][1]] \
				if submao[i].x > submao[j].x \
				else [submao[j][0], submao[j][1]]
				break
	
	return r

func analisar_dois_pares() -> Array:
	var r1 = DEFAULT.duplicate()
	var r2 = DEFAULT.duplicate()
	
	r1 = analisar_par()
	if r1 != DEFAULT:
		r2 = analisar_par(r1[1])
	
	if r1 != DEFAULT and r2 != DEFAULT:
		return r1 if r1[1] > r2[1] else r2
	
	return DEFAULT

func analisar_trinca() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 3:
			break
		else:
			c = 0
	
	if c == 3:
		r = [nai, num]
	
	return r

func analisar_familia() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	var nai = 0
	
	
	for i in range(submao.size()):
		if submao[i][1] == 1:
			nai = submao[i][0]
			if submao.has(Vector2i(nai, 2)) and submao.has(Vector2i(nai, 3)):
				break
			else:
				nai = 0
	if nai != 0:
		r = [nai, 3]

	return r

func analisar_sequencia() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	var nai = 0
	
	for i in range(submao.size()):
		if submao[i][1] == 1:
			nai = submao[i][0]
			if submao.has(Vector2i(nai, 2)) and \
			submao.has(Vector2i(nai, 3)) and \
			submao.has(Vector2i(nai, 4)):
				break
			else:
				nai = 0
	if nai != 0:
		r = [nai, 4]

	return r

func analisar_flush() -> Array:
	var r = [-2, -2]
	
	var nai = submao[0][0]
	
	if submao.filter(func(a): return a[1] == nai).size() == 5:
		r = submao[-1]
	
	return r

func analisar_full_house() -> Array:
	var r1 = DEFAULT.duplicate()
	var r2 = DEFAULT.duplicate()
	
	r1 = analisar_trinca()
	if r1 != DEFAULT:
		r2 = analisar_par(r1[1])
	
	if r1 != DEFAULT and r2 != DEFAULT:
		return r1
	
	return DEFAULT

func analisar_familia_completa() -> Array:
	var r1 = DEFAULT.duplicate()
	var c = 0
	
	r1 = analisar_trinca()
	if r1[1] == 1:
		for carta in submao:
			if carta[1] == 1:
				c += 1
			if carta[1] == 2:
				c += 1
			if c == 2:
				return r1
		
	return DEFAULT

func analisar_quadra() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 4:
			r = [nai, num]
			break
		else:
			c = 0
	
	return r

func analisar_quina() -> Array:
	# lista default com valores menores do que o menor valor possível (cenoura = (-1, -1))
	var r = DEFAULT.duplicate()
	var c = 0
	var num
	var nai
	var h = []
	
	for i in range(submao.size()-1):
		num = submao[i][1]
		if not h.has(num):
			h.append(num)
			c += 1
			for j in range(i+1, submao.size()):
				if submao[j][1] == num:
					c += 1
					nai = submao[j][0]
			
		if c == 5:
			r = [nai, num]
			break
		else:
			c = 0
	
	return r

func analisar_exodia() -> Array:
	var r = [-2, -2]
	
	if submao.filter(func(a): return a[1] == 5).size() == 5:
		r = [5, 5]
	
	return r
