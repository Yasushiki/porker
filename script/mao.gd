class_name Mao extends Node

var baralho: Baralho
var mao: Array[Vector2i] = [Vector2i(), Vector2i(), Vector2i(), Vector2i(), Vector2i()]
var submao: Array[Vector2i]
var info_mao: Dictionary = {}

var custo: int

signal tem_selecionada(flag)

@export var inimigo: bool = false

func _ready() -> void:
	# se a mão é do inimigo, muda todas as cartas para cartas do inimigo (viradas)
	if inimigo:
		for filha in get_children():
			if filha is Node2D:
				filha.inimigo = true
	
	for filha in get_children():
		if filha.has_signal("foi_selecionada"):
			filha.connect("foi_selecionada", _on_foi_selecionada.bind(filha))
			filha.connect("foi_desselecionada", _on_foi_desselecionada.bind(filha))

func _on_foi_selecionada(naipe, ranque, _filha):
	# manda um sinal falando que tem cartas selecionadas
	emit_signal("tem_selecionada", true)
	
	# coloca as cartas selecionadas na variável submao
	submao.append(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	
	# processa a submão e verifica qual a mão atual
	info_mao = Verificador.verificar_mao(submao)
	custo = Verificador.calcular_custo(info_mao)
	
	imprimir_mao()

func _on_foi_desselecionada(naipe, ranque, _filha):
	# remove as cartas desselecionadas da submão
	submao.erase(Vector2i(naipe, ranque))
	submao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	
	# se a submão não está vazia, reprocessa ela 
	if not submao.is_empty():
		info_mao = Verificador.verificar_mao(submao)
		custo = Verificador.calcular_custo(info_mao)
		imprimir_mao()
	# submão vazia, emite um sinal falando que não tem mais cartas selecionadas
	else:
		custo = 0
		$Nome.text = ""
		emit_signal("tem_selecionada", false)


func set_baralho(ref_baralho: Baralho) -> void:
	baralho = ref_baralho
	
func ordenar_mao() -> void:
	mao.sort_custom(func(a: Vector2i, b: Vector2i): return a < b)
	mao.sort_custom(func(_a: Vector2i, b: Vector2i): return b == Vector2i())
	for i in range(mao.size()):
		if mao[i] == Vector2i():
			var c = get_node("Carta%d" % i)
			c.visible = false
	
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
				carta.selecionar_sprite(Vector2i(-2, -2))

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
	
	emit_signal("tem_selecionada", false)
	
	for i in range(c):
		comprar_carta()
	
	$Nome.text = ""
	submao.clear()
	ordenar_mao()
	renderizar_mao()


func jogar_selecionadas(m = []) -> void:
	if m == []:
		var cartas: Array = get_children().filter(func(a): return a is Node2D)
		
		for i in range(cartas.size()):
			if cartas[i].selecionado:
				cartas[i].desselecionar()
				mao[i] = Vector2i()
		
		emit_signal("tem_selecionada", false)
		
		$Nome.text = ""
		submao.clear()
	
	else:
		var cartas: Array = get_children().filter(func(a): return a is Node2D)
		
		for i in range(cartas.size()):
			if m.has(Vector2i(cartas[i].naipe, cartas[i].ranque)):
				mao[i] = Vector2i()
		
		submao.clear()

func completar_mao() -> void:
	var qt = mao.filter(func(a): return a == Vector2i()).size()
	for i in range(qt):
		comprar_carta()
	ordenar_mao()
	renderizar_mao()


func imprimir_mao() -> void:
	match info_mao.tipo:
		0:
			$Nome.text = "Carta alta"
		1:
			$Nome.text = "Par"
		2:
			$Nome.text = "Dois pares"
		3:
			$Nome.text = "Trinca"
		4:
			$Nome.text = "Família"
		5: 
			$Nome.text = "Sequência"
		6:
			$Nome.text = "Flush"
		7:
			$Nome.text = "Full House"
		8:
			$Nome.text = "Família completa"
		9:
			$Nome.text = "Quadra"
		10:
			$Nome.text = "Quina"
		11:
			$Nome.text = "EXÓDIA!!!"
	
	$Nome.text += "\nR$%d" % custo
