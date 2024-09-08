extends CanvasLayer

signal start_game
signal reset_game

signal choice(yes: bool)

const MAXN = 32767

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func disp_message(s: String, line=0) -> void:
	var cont = $Texts.get_children()[line]
	cont.text = s	
	
func change_number(num: int) -> void:
	if num < 0:
		$NumDisplay.text = ".".repeat(-num)
	else:
		$NumDisplay.text = str(num)
		
func get_backn() -> int:
	return int($SetN/TextEdit.text)
	
func set_choice_buttons_visibility(b: bool) -> void:
	$ButtonYes.visible = b
	$ButtonNo.visible = b
	
func set_choice_buttons_availability(b: bool) -> void:
	$ButtonYes.disabled = not b
	$ButtonNo.disabled = not b


func _on_start_btn_pressed() -> void:
	$StartBtn.hide()
	$SetN/TextWhereN.hide()
	$SetN/TextEdit.hide()
	start_game.emit()


func _on_text_edit_text_changed() -> void:
	var num = int($SetN/TextEdit.text)
	if not num or num < 1:
		num = 1
		$SetN/TextEdit.text = str(num)
	elif num > MAXN:
		num = MAXN
		$SetN/TextEdit.text = str(num)


func _on_button_go_back_pressed() -> void:
	reset_game.emit()


func _on_button_yes_pressed() -> void:
	choice.emit(true)


func _on_button_no_pressed() -> void:
	choice.emit(false)
