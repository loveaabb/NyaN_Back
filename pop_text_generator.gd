extends Control

@export var pop_text_scene: PackedScene
@export var text_size: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func emit_text(text: String,
 pos: Vector2 = position,
 color: Color = Color(0, 0, 0, 1),
 spd: Vector2 = Vector2(0, -100)) -> void:
	var textIns = pop_text_scene.instantiate()
	
	textIns.text = text
	textIns.position = pos
	textIns.add_theme_color_override("font_color", color)
	textIns.speed = spd
	textIns.add_theme_font_size_override("font_size", text_size)
	
	add_child(textIns)
