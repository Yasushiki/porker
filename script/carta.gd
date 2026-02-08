extends Node2D

var selecionado: bool = false
var inimigo: bool = false

var naipe: int
var ranque: int

signal foi_selecionada(naipe, ranque)
signal foi_desselecionada(naipe, ranque)

func selecionar_sprite(carta: Vector2i) -> void:
	naipe = carta.x
	ranque = carta.y
	if carta == Vector2i(0, 0):
		$Sprite.texture = load("res://placeholder/sprite/fundo.png")
	elif carta == Vector2i(-1, -1):
		$Sprite.texture = load("res://placeholder/sprite/cenoura.png")
	else:
		$Sprite.texture = load("res://placeholder/sprite/%d-%d.png" % [carta.x, carta.y])
	

func _on_area_mouse_entered() -> void:
	if not inimigo:
		if not selecionado:
			$Sprite.scale = Vector2(1.1, 1.1)
			self.z_index = 2
			Global.hover = true
	

func _on_area_mouse_exited() -> void:
	if not inimigo:
		if not selecionado:
			$Sprite.scale = Vector2(1, 1)
			self.z_index = 0
			Global.hover = false
	

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if not inimigo:
		if event is InputEventMouseButton and event.is_action_pressed("mouse_click") and event.button_index == 1:
			$Sprite.scale = Vector2(1, 1)
			if not selecionado:
				selecionado = true
				emit_signal("foi_selecionada", naipe, ranque)
				self.position.y -= 70
				self.scale = Vector2(1.1, 1.1)
				self.z_index = 1
				Global.hover = false
			elif selecionado and not Global.hover:
				selecionado = false
				emit_signal("foi_desselecionada", naipe, ranque)
				self.position.y += 70
				self.scale = Vector2(1, 1)
				self.z_index = 0
				_on_area_mouse_entered.call()

func desselecionar() -> void:
	selecionado = false
	self.position.y += 70
	self.scale = Vector2(1, 1)
	self.z_index = 0
