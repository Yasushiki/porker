class_name Jogador extends Node2D

var baralho: Baralho = Baralho.new()

var vida: int = 6
var dinheiro: int = 50

signal jogar
signal descartar

func _ready() -> void:
	$Mao.connect("tem_selecionada", _on_tem_selecionada.bind($Mao))
	$Vida.text = "<3 ".repeat(vida)
	$Dinheiro.text = "R$" + str(dinheiro)

func setup() -> void:
	$Mao.set_baralho(baralho) # compõe a instância da mão com a instância do baralho
	$Mao.criar_mao()

func _on_tem_selecionada(flag, _filha):
	if flag:
		$Descartar.disabled = false
		$Jogar.disabled = false
		$Descartar.visible = true
		$Jogar.visible = true
	else:
		$Descartar.disabled = true
		$Jogar.disabled = true
		$Descartar.visible = false
		$Jogar.visible = false


func _on_descartar_pressed() -> void:
	$Mao.descartar_selecionadas()
	emit_signal("descartar")

func _on_jogar_pressed() -> void:
	$Mao.jogar_selecionadas()
	emit_signal("jogar")

func baralho_vazio() -> bool:
	if baralho.monte.is_empty():
		return true
	else:
		return false

func atualizar_vida(v: int):
	vida += v
	$Vida.text = "<3 ".repeat(vida)

func atualizar_dinheiro(d: int):
	dinheiro += d
	$Dinheiro.text = "R$" + str(dinheiro)
