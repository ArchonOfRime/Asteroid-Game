extends Node2D
var d = 0
var radius = 300
var speed = 2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	d += delta
	
	var cardinal_size = Vector2(sin(d)/20 + 1,sin(d)/20 + 1)
	var ordinal_size = Vector2(cos(d)/20 + 1,cos(d)/20 + 1)
	$cardinal.scale = cardinal_size
	$ordinal.scale = ordinal_size
	
	$player/square_one.rotation = d/2
	$player/square_two.rotation = -d/2
