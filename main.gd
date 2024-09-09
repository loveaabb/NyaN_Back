extends Node2D

var numberQueue := []
var backN := 2
var turnTime := 3.0
var turnState := 0
var maxState := 10
var currentTurn := 0
var acceptChoice := false
var countdownNum := 3
var chosen := true
var rightTimes := 0
var wrongTimes := 0
var missTimes := 0

var RNG = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset_game()
	get_window().title = "NyaN-Back by Loveaabb"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func count() -> void:
	countdownNum -= 1
	$UI.change_number(countdownNum)
	
func is_size_reached_n() -> bool:
	return numberQueue.size() == backN + 1
	
func is_numbers_match() -> bool:
	return (numberQueue.back() == numberQueue.front())
	
func randi_skip_num(minn: int, maxn: int, skip: int) -> int:
	var rawrn = RNG.randi_range(minn, maxn - 1)
	var res = 0
	
	if rawrn >= skip:
		res = rawrn + 1
	else:
		res = rawrn
		
	return res

func pregame() -> void:
	$UI.disp_message("The game starts in", 0)
	$UI.disp_message("seconds", 1)
	$UI.change_number(countdownNum)
	$UI/ButtonGoBack.show()
	backN = $UI.get_backn()
	$PregameCountDown.start()

func game_start() -> void:
	turnState = 0
	
	$gameCounter.wait_time = turnTime / maxState
	$gameCounter.start()
	
func next_turn() -> void:
	var num = 0
	if numberQueue.size() == backN + 1:
		numberQueue.pop_front()
		if RNG.randf() > 0.5:
			num = numberQueue.front()
		else:
			num = randi_skip_num(0, 9, numberQueue.front())
	else:
		num = RNG.randi_range(0, 9)
	numberQueue.push_back(num)

	acceptChoice = false
	$UI.set_choice_buttons_availability(acceptChoice)
	currentTurn += 1
	
func reset_game() -> void:
	$PregameCountDown.stop()
	$gameCounter.stop()
	
	numberQueue = []
	turnState = 0
	maxState = 10
	currentTurn = 0
	acceptChoice = false
	countdownNum = 3
	chosen = true
	rightTimes = 0
	wrongTimes = 0
	missTimes = 0

	
	$UI.set_choice_buttons_visibility(false)
	$UI.set_choice_buttons_availability(false)
	$UI.disp_message("Welcome", 0)
	$UI.change_number(2)
	$UI.disp_message("NyaN-Back! :3", 1)
	$UI.disp_message("", 2)
	$UI/TextStats.text = ""
	$UI/StartBtn.show()
	$UI/ButtonGoBack.hide()
	$UI/SetN/TextWhereN.show()
	$UI/SetN/TextEdit.show()
	
func update_stats():
	var total = wrongTimes + rightTimes + missTimes
	$UI/TextStats.text = "C/W/M: %d/%d/%d  Accuracy: %.1f%%" \
	% [rightTimes, wrongTimes, missTimes, 1.0 * rightTimes / total * 100.0]

func _on_pregame_count_down_timeout() -> void:
	if countdownNum > 1:
		count()
		if countdownNum == 1:
			$UI.disp_message("second", 1)
	else:
		$PregameCountDown.stop()
		game_start()


func _on_game_counter_timeout() -> void:
	if turnState == 0:
		next_turn()
		$UI.disp_message("Turn #" + str(currentTurn), 0)
		$UI.disp_message("N = " + str(backN), 1)
		
		if currentTurn == 1:
			$UI.set_choice_buttons_visibility(true)
		
		if not chosen:
			$UI/PopTextGenerator.emit_text("Miss!", position, Color.RED)
			missTimes += 1
			update_stats()
		
		if is_size_reached_n():
			chosen = false
			$UI.disp_message("Get ready...", 2)
		else:
			$UI.disp_message("", 2)
			
	if turnState <= 2:
		$UI.change_number(-turnState - 1)
	elif turnState == 3:
		$UI.change_number(numberQueue.back())
		if is_size_reached_n():
			acceptChoice = true
			$UI.disp_message("Make your choice", 2)
		
	$UI.set_choice_buttons_availability(acceptChoice)
		
	turnState = (turnState + 1) % maxState


func _on_ui_choice(yes: bool) -> void:
	if acceptChoice:
		if is_numbers_match() == yes:
			$UI/PopTextGenerator.emit_text("Correct!", position, Color.GREEN)
			rightTimes += 1
			update_stats()
		else:
			$UI/PopTextGenerator.emit_text("Wrong!", position, Color.RED)
			wrongTimes += 1
			update_stats()
			
		acceptChoice = false
		chosen = true
		$UI.set_choice_buttons_availability(acceptChoice)
