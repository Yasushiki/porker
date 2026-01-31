class_name Baralho extends RefCounted

# ESSES DOIS VALORES DEVEM SER 6 (5 naipes e 5 ranques)
const NAIPE_PLACEHOLDER_MUDAR_DEPOIS = 4+1
const RANQUE_PLACEHOLDER_MUDAR_DEPOIS = 3+1

var monte: Array[Vector2i] = []
var descarte: Array[Vector2i] = []

func criar_baralho():
	for naipe in range(1, NAIPE_PLACEHOLDER_MUDAR_DEPOIS): # naipes
		for ranque in range(1, RANQUE_PLACEHOLDER_MUDAR_DEPOIS): # ranques
			monte.append(Vector2i(naipe, ranque))
			# --- RANQUES ---
			# 1 - Leitão
			# 2 - Porco
			# 3 - Porca
			# 4 - Zhu Bajie
			# 5 - Parte do exódia
	
	monte.append(Vector2i(-1, -1)) # cenoura

func adicionar_carta(carta: Vector2i):
	monte.append(carta)

func descartar_carta(carta: Vector2i):
	monte.erase(carta)
	descarte.append(carta)

func recriar_monte() -> void:
	for carta in descarte:
		descarte.erase(carta)
		monte.append(carta)
