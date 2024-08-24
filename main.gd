extends Node2D
var d = PI/8
var player_rotation = 0
var speed = PI / (2**9)

var timer = 0
var multiplier = 0
var score_position = (randi() % 4)
var last = score_position
const adder = 1
var end_state = false
var collect = false

# Called when the node enters the scene tree for the first time.
func _ready():
	player_rotation = (randi() % 4) * PI/2 + PI/4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://menu.tscn")
	d += delta
	
	if (timer > 2 and not end_state):
		timer = 0
		multiplier = 1
		speed = PI / (2**9)
		
	if not Input.is_anything_pressed():
		timer += delta
	elif (multiplier == 1):
		speed = PI / (2**8)
	elif (multiplier == 5):
		speed = PI / (2**7)
	elif (multiplier == 10):
		speed = PI / (2**6)
	elif (multiplier == 13):
		speed = PI / (2**5)
	
	var player_position = 300 - multiplier * 14
	var counter_position = 7.4 * multiplier - 150
	
	if (not end_state):
		var size_down = 1 - (0.025 * multiplier)
		var cardinal_size = Vector2(sin(d)/20 + size_down ,sin(d)/20 + size_down)
		var ordinal_size = Vector2(cos(d)/20 + size_down, cos(d)/20 + size_down)
		$cardinal.scale = cardinal_size
		$ordinal.scale = ordinal_size
	
		$player/square_one.rotation = d /2
		$player/square_two.rotation = -d / 2
		$counter/square_one.rotation = d / 2
		$counter/square_two.rotation = -d / 2
		
		size_down = 300 - multiplier * 15
		$player/square_one.position.x = player_position
		$player/square_two.position.x  = player_position
		size_down = -150 + multiplier * 7.5
		$counter/square_one.position.x  = counter_position
		$counter/square_two.position.x  = counter_position
		
		$outer_ring.rotation = d/4
		$outer_ring2.rotation = -d/4
		var scale_down = 1 - multiplier * 0.02
		$outer_ring.scale = Vector2 (scale_down, scale_down)
		$outer_ring2.scale = Vector2 (scale_down, scale_down)
	else:
		var cardinal_size = Vector2(sin(2 * d)/20 - 0.5,sin(2 * d)/20 - 0.5)
		var ordinal_size = Vector2(cos(2 * d)/20 - 0.5, cos(2 * d)/20 - 0.5)
		$cardinal.scale = cardinal_size 
		$ordinal.scale = ordinal_size
		$cardinal/up_point.modulate = Color("White")
		$cardinal/right_point.modulate = Color("White")
		$cardinal/down_point.modulate = Color("White")
		$cardinal/left_point.modulate = Color("White")
		
		$player/square_one.rotation = d * 5
		$player/square_two.rotation = -d * 5
		$counter/square_one.rotation = d * 5
		$counter/square_two.rotation = -d * 5
		$player/square_one.position.x = 0
		$player/square_two.position.x  = 0
		$counter/square_one.position.x  = 0
		$counter/square_two.position.x  = 0
	
		$outer_ring.rotation = d 
		$outer_ring2.rotation = -d
		$outer_ring.scale = Vector2 (0.6, 0.6)
		$outer_ring2.scale = Vector2 (0.6, 0.6)
	
	# Player movement
	var location = $player/square_one.global_position

	# Cardinal movement
	if Input.is_action_pressed("up") and not (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		# Orbit Counter-Clockwise
		if (location.x > 500 and not location.y == 200 + multiplier * 14): 
			player_rotation -= speed 
		# Orbit Clockwise
		elif (location.x <= 500 and not location.y == 200 + multiplier * 14):
			player_rotation += speed
		else:
			player_rotation =  PI * 3 / 2
	elif Input.is_action_pressed("right") and not (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		# Orbit Counter-Clockwise
		if (location.y > 500 and not location.x == 800 - multiplier * 14): 
			player_rotation -= speed 
		# Orbit Clockwise
		elif (location.y <= 500 and not location.x == 800 - multiplier * 14):
			player_rotation += speed 
		else:
			player_rotation =  0
	elif Input.is_action_pressed("down") and not (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		# Orbit Counter-Clockwise
		if (location.x < 500 and not location.y == 800 - multiplier * 14): 
			player_rotation -= speed
		# Orbit Clockwise
		elif (location.x >= 500 and not location.y == 800 - multiplier * 14):
			player_rotation += speed 
		else:
			player_rotation =  PI / 2
	elif Input.is_action_pressed("left") and not (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		# Orbit Counter-Clockwise
		if (location.y < 500 and not location.x == 200 + multiplier * 14): 
			player_rotation -= speed
		# Orbit Clockwise
		elif (location.y >= 500 and not location.x == 200 + multiplier * 14):
			player_rotation += speed
		else:
			player_rotation =  PI

	$player.rotation = player_rotation
	$counter.rotation = player_rotation
	
	# Binary collapse
	if (multiplier > 20 and end_state == false):
		end_state = true
		$transition.emitting = true
	
	# Score setter
	if (collect == false):
		while (score_position == last):
			score_position = (randi() % 4) + 1
		collect = true
		if (score_position == 1):
			$cardinal/up_point.modulate = Color("DODGER_BLUE")
		elif (score_position == 2):
			$cardinal/right_point.modulate = Color("DODGER_BLUE")
		elif (score_position == 3):
			$cardinal/down_point.modulate = Color("DODGER_BLUE")
		elif (score_position == 4):
			$cardinal/left_point.modulate = Color("DODGER_BLUE")
	
	# Score getter
	if (score_position == 1 and (player_rotation ==  PI * 3 / 2)):
		multiplier += 1
		collect = false
		last = score_position
		$cardinal/up_point.modulate = Color("White")
	elif (score_position == 2 and (player_rotation ==  0)):
		multiplier += 1
		collect = false
		last = score_position
		$cardinal/right_point.modulate = Color("White")
	elif (score_position == 3 and (player_rotation ==  PI / 2)):
		multiplier += 1
		collect = false
		last = score_position
		$cardinal/down_point.modulate = Color("White")
	elif (score_position == 4 and (player_rotation ==  PI)):
		multiplier += 1
		collect = false
		last = score_position
		$cardinal/left_point.modulate = Color("White")
	
	#$indicator.text = "Multiplier:" + str(multiplier)


