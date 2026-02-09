class_name Baralho extends RefCounted

const QT_NAIPE = 6
const QT_RANQUE = 6

var monte: Array[Vector2i] = []
var descarte: Array[Vector2i] = []

const CENOURA = Vector2i(-1, -1)

func _init():
	for naipe in range(1, QT_NAIPE): # naipes
		for ranque in range(1, QT_RANQUE): # ranques
			monte.append(Vector2i(naipe, ranque))
			# --- RANQUES ---
			# 1 - Leitão
			# 2 - Porco
			# 3 - Porca
			# 4 - Zhu Bajie
			# 5 - Parte do exódia
	
	monte.append(CENOURA) # cenoura

func adicionar_carta(carta: Vector2i):
	monte.append(carta)

func descartar_carta(carta: Vector2i):
	monte.erase(carta)
	descarte.append(carta)

func recriar_monte() -> void:
	for carta in descarte:
		descarte.erase(carta)
		monte.append(carta)
