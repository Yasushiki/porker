class_name Baralho

# ESSES DOIS VALORES DEVEM SER 6 (5 naipes e 5 ranques)
const NAIPE_PLACEHOLDER_MUDAR_DEPOIS = 4+1
const RANQUE_PLACEHOLDER_MUDAR_DEPOIS = 3+1

var monte: Array[Vector2] = []
var descarte: Array[Vector2] = []

func criar_baralho():
	for naipe in range(1, NAIPE_PLACEHOLDER_MUDAR_DEPOIS): # naipes
		for ranque in range(1, RANQUE_PLACEHOLDER_MUDAR_DEPOIS): # ranques
			monte.append(Vector2(naipe, ranque))
			# --- RANQUES ---
			# 1 - Leitão
			# 2 - Porco
			# 3 - Porca
			# 4 - Zhu Bajie
			# 5 - Parte do exódia
	
	monte.append(Vector2(0, 0)) # cenoura

func adicionar_carta(carta: Carta):
	monte.append(Vector2(carta.naipe, carta.ranque))

func remover_carta(carta: Carta):
	monte.erase(Vector2(carta.naipe, carta.ranque))
	descarte.append(Vector2(carta.naipe, carta.ranque))
