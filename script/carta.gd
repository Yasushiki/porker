class_name Carta extends Node2D

@export var numero: int
@export var naipe: String

@export var indice: int

var selecionado = false

func _ready() -> void:
	$Sprite.texture = load("res://sprite/%d-%s.png" % [numero, naipe])

func _on_area_mouse_entered() -> void:
	if not selecionado:
		$Sprite.scale = Vector2(1.15, 1.15)
		self.z_index = 2

func _on_area_mouse_exited() -> void:
	if not selecionado:
		$Sprite.scale = Vector2(1, 1)
		self.z_index = 0

func _on_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_action_pressed("mouse_click") and event.button_index == 1:
		if not selecionado:
			selecionado = true
			self.position.y -= 70
			self.scale = Vector2(1.25, 1.25)
			self.z_index = 1
			self.rotation = 0
		elif selecionado:
			selecionado = false
			self.position.y += 70
			self.scale = Vector2(1, 1)
			self.z_index = 0
			self.rotation = (indice*5)*PI/180.0
