extends Node2D
var d = PI/8
var player_rotation = 0
var speed = PI / (2**2)

var timer = 0
var multiplier = 1
const adder = PI / (2**10)

# Called when the node enters the scene tree for the first time.
func _ready():
	player_rotation = (randi() % 4) * PI/2 + PI/4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("esc"):
		get_tree().change_scene_to_file("res://menu.tscn")
	d += delta
	
	if timer > 5:
		timer = 0
		multiplier = 1
	
	var cardinal_size = Vector2(sin(d)/20 - 0.5,sin(d)/20 - 0.5)
	var ordinal_size = Vector2(cos(d)/20 - 0.5, cos(d)/20 - 0.5)
	$cardinal.scale = cardinal_size 
	$ordinal.scale = ordinal_size
	
	$player/square_one.rotation = d * 2
	$player/square_two.rotation = -d * 2
	$counter/square_one.rotation = d * 2
	$counter/square_two.rotation = -d * 2
	$outer_ring.rotation = d/4
	$outer_ring2.rotation = -d/4
	
	
	# Player movement
	var location = $player/square_one.global_position

	# Cardinal movement
	if Input.is_action_pressed("up") and not (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		# Orbit Counter-Clockwise
		if (location.x > 500 and not location.y == 200): 
			player_rotation -= speed 
		# Orbit Clockwise
		elif (location.x <= 500 and not location.y == 200):
			player_rotation += speed
		else:
			player_rotation =  PI * 3 / 2
	elif Input.is_action_pressed("right") and not (Input.is_action_pressed("up") or Input.is_action_pressed("down")):
		# Orbit Counter-Clockwise
		if (location.y > 500 and not location.x == 800): 
			player_rotation -= speed 
		# Orbit Clockwise
		elif (location.y <= 500 and not location.x == 800):
			player_rotation += speed 
		else:
			player_rotation =  0
	elif Input.is_action_pressed("down") and not (Input.is_action_pressed("right") or Input.is_action_pressed("left")):
		# Orbit Counter-Clockwise
		if (location.x < 500 and not location.y == 800): 
			player_rotation -= speed
		# Orbit Clockwise
		elif (location.x >= 500 and not location.y == 800):
			player_rotation += speed 
		else:
			player_rotation =  PI / 2
	elif Input.is_action_pressed("left") and not (Input.is_action_pressed("up") or Input.is_action_pressed("down")):

		# Orbit Counter-Clockwise
		if (location.y < 500 and not location.x == 200): 
			player_rotation -= speed
		# Orbit Clockwise
		elif (location.y >= 500 and not location.x == 200):
			player_rotation += speed
		else:
			player_rotation =  PI

	$player.rotation = player_rotation
	$counter.rotation = player_rotation
	
	if not Input.is_anything_pressed():
		timer += delta
	
	$player/square_one.position.x = 0
	$player/square_two.position.x  = 0
	$counter/square_one.position.x  = 0
	$counter/square_two.position.x  = 0
	
	# Binary collapse
