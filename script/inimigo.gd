class_name Inimigo extends RefCounted

var baralho: Baralho = Baralho.new()
var mao: Mao
var vida: int
var dinheiro: int
var nivel: int

func _init(n: int):
	nivel = n

func setup_baralho(n: int):
	match n:
		pass

func setup_parametros(n: int):
	match n:
		1:
			vida = 3
			dinheiro = 30

func setup_mao():
	mao.set_baralho(baralho)
	mao.criar_mao(true)

func decidir_descarte():
	pass

func decidir_mao():
	pass

func ia():
	decidir_descarte()
	decidir_mao()
