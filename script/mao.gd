class_name Mao extends Node

var baralho: Baralho
var mao: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i(), Vector2i()]

var custo: int

var submao: Array[Vector2i]

var info_mao = [0,0,0,0]

@export var inimigo: bool = false

func _ready() -> void:
	if inimigo:
		for filha in get_children():
			if filha is Node2D:
				filha.inimigo = true
	
	for filha in get_children():
		if filha.has_signal("foi_selecionada"):
			filha.connect("foi_selecionada", _on_foi_selecionado.bind(filha))
			filha.connect("foi_desselecionada", _on_foi_desselecionado.bind(filha))


func _on_foi_selecionado(naipe, ranque, _filha):
	submao.append(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	info_mao = Verificador.verificar_mao(submao)
	custo = Verificador.calcular_custo(info_mao)
	imprimir_mao(info_mao)

func _on_foi_desselecionado(naipe, ranque, _filha):
	submao.erase(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	if not submao.is_empty():
		info_mao = Verificador.verificar_mao(submao)
		custo = Verificador.calcular_custo(info_mao)
		imprimir_mao(info_mao)
	else:
		custo = 0
		$Nome.text = ""


func set_baralho(ref_baralho: Baralho) -> void:
	baralho = ref_baralho
	
func ordenar_mao() -> void:
	mao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	mao.sort_custom(func(_a: Vector2i, b: Vector2i): return b == Vector2i())
	
func renderizar_mao() -> void:
	# Se estiver no modo de debug, as cartas do inimigos serão mostradas
	if OS.is_debug_build():
		var cartas: Array = get_children().filter(func(a): return a is Node2D)
		var i: int = 0
		for carta in cartas:
			carta.selecionar_sprite(mao[i])
			i += 1
		
	# Se estiver no modo de release, as cartas do inimigo estarão viradas
	else:
		if not inimigo:
			var cartas: Array = get_children().filter(func(a): return a is Node2D)
			var i: int = 0
			for carta in cartas:
				carta.selecionar_sprite(mao[i])
				i += 1
		else:
			var cartas: Array = get_children().filter(func(a): return a is Node2D)
			for carta in cartas:
				carta.selecionar_sprite(Vector2i(0, 0))
	
func comprar_carta() -> void:
	if not baralho.monte.is_empty():
		var carta: Vector2i = baralho.monte.pick_random()
		
		baralho.descartar_carta(carta)
		for i in range(5):
			if mao[i] == Vector2i():
				mao[i] = carta
				break
	
func criar_mao() -> void:
	for i in range(5):
		comprar_carta()
	ordenar_mao()
	renderizar_mao()
	
func descartar_selecionadas() -> void:
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
	renderizar_mao()


func imprimir_mao(m: Array) -> void:
	match m[0]:
		0:
			$Nome.text = "Carta alta"
			print("Carta alta - Maior carta: %d%d" % [m[1], m[2]])
		1:
			$Nome.text = "Par"
			print("Par - Maior carta: %d%d" % [m[1], m[2]])
		2:
			$Nome.text = "Dois pares"
			print("Dois Pares - Maior carta: %d%d" % [m[1], m[2]])
		3:
			$Nome.text = "Trinca"
			print("Trinca - Maior carta: %d%d" % [m[1], m[2]])
		4:
			$Nome.text = "Família"
			print("Família - Maior carta: %d%d" % [m[1], m[2]])
		5: 
			$Nome.text = "Sequência"
			print("Sequência - Maior carta: %d%d" % [m[1], m[2]])
		6:
			$Nome.text = "Flush"
			print("Flush - Maior carta: %d%d" % [m[1], m[2]])
		7:
			$Nome.text = "Full House"
			print("Full House - Maior carta: %d%d" % [m[1], m[2]])
		8:
			$Nome.text = "Família completa"
			print("Família Completa - Maior carta: %d%d" % [m[1], m[2]])
		9:
			$Nome.text = "Quadra"
			print("Quadra - Maior carta: %d%d" % [m[1], m[2]])
		10:
			$Nome.text = "Quina"
			print("Quina - Maior carta: %d%d" % [m[1], m[2]])
		11:
			$Nome.text = "EXÓDIA!!!"
			print("Exodia - Maior carta: %d%d" % [m[1], m[2]])
	
	$Nome.text += "\nR$%d" % custo
