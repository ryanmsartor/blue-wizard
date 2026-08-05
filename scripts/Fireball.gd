extends Area2D

export var speed = 128

const offscreen_left	: int = -16
const offscreen_up		: int = -16
var offscreen_right		: int
var offscreen_down		: int

# Called when the node enters the scene tree for the first time.
func _ready():
	offscreen_right = get_parent().screen_size.x + 16
	offscreen_down = get_parent().screen_size.y + 16

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# move in the direction of the sprite rotation
	var velocity = (Vector2.UP * speed).rotated(rotation)
	position += (velocity * delta)
	
	# delete self once offscreen
	if position.x <= offscreen_left or \
		position.y <= offscreen_up or \
		position.x >= offscreen_right or \
		position.y >= offscreen_down:
		self.queue_free()



func _on_Fireball_area_entered(_area):
	if not Global.attacks_pierce:
		self.queue_free()
