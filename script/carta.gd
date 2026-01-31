class_name Carta extends Node2D

var naipe: int
var ranque: int

var selecionado: bool = false

func atualizar_valor(carta: Vector2):
	self.naipe = abs(carta.x)
	self.ranque = abs(carta.y)
	$Sprite.texture = load("res://placeholder/sprite/%d-%d.png" % [naipe, ranque])

func _on_area_mouse_entered() -> void:
	if not selecionado:
		$Sprite.scale = Vector2(1.1, 1.1)
		self.z_index = 2
		Global.hover = true
	

func _on_area_mouse_exited() -> void:
	if not selecionado:
		$Sprite.scale = Vector2(1, 1)
		self.z_index = 0
		Global.hover = false
	

func _on_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and \
	event.is_action_pressed("mouse_click") and \
	event.button_index == 1:
		$Sprite.scale = Vector2(1, 1)
		if not selecionado:
			selecionado = true
			self.position.y -= 70
			self.scale = Vector2(1.1, 1.1)
			self.z_index = 1
			Global.hover = false
		elif selecionado and not Global.hover:
			selecionado = false
			self.position.y += 70
			self.scale = Vector2(1, 1)
			self.z_index = 0
			_on_area_mouse_entered.call()
		
	
