extends Label

var fadeOutSpeed = 1
var speed = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var currentColor = get_theme_color("font_color")
	var targetAlpha = currentColor.a - fadeOutSpeed * delta
	var targetColor = currentColor
	targetColor.a = targetAlpha
	position += (speed * delta)
	if targetAlpha >= 0:
		add_theme_color_override("font_color", targetColor)
	else:
		queue_free()
		
