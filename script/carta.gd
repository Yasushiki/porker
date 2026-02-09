extends Node2D

var selecionado: bool = false
var inimigo: bool = false

@export var selecionavel = true

var naipe: int
var ranque: int

var pequeno = 1
var grande = 1.1

signal foi_selecionada(naipe, ranque)
signal foi_desselecionada(naipe, ranque)

func selecionar_sprite(carta: Vector2i, fundo: bool = false) -> void:
	naipe = carta.x
	ranque = carta.y
	if carta == Vector2i(0, 0):
		$Sprite.texture = null
	elif fundo == true:
		$Sprite.texture = load("res://sprite/fundo.png")
	elif carta == Vector2i(-1, -1):
		$Sprite.texture = load("res://sprite/cenoura.png")
	else:
		$Sprite.texture = load("res://sprite/%d-%d.png" % [carta.x, carta.y])

func _on_area_mouse_entered() -> void:
	if not inimigo and selecionavel:
		if not selecionado:
			$Sprite.scale = Vector2(grande, grande)
			self.z_index = 2
			Global.hover = true
	

func _on_area_mouse_exited() -> void:
	if not inimigo and selecionavel:
		if not selecionado:
			$Sprite.scale = Vector2(pequeno, pequeno)
			self.z_index = 0
			Global.hover = false
	

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not inimigo and selecionavel:
		if event is InputEventMouseButton and event.is_action_pressed("mouse_click") and event.button_index == 1:
			if not selecionado:
				selecionado = true
				emit_signal("foi_selecionada", naipe, ranque)
				self.position.y -= 70
				self.scale = Vector2(grande, grande)
				self.z_index = 1
				Global.hover = false
			elif selecionado and not Global.hover:
				selecionado = false
				emit_signal("foi_desselecionada", naipe, ranque)
				self.position.y += 70
				self.scale = Vector2(pequeno, pequeno)
				self.z_index = 0
				_on_area_mouse_entered.call()

func desselecionar() -> void:
	selecionado = false
	self.position.y += 70
	self.scale = Vector2(pequeno, pequeno)
	self.z_index = 0
