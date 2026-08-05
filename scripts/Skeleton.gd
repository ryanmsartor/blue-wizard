extends Area2D

var move_speed: int
var health: int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Skeleton spawned at ", position.x, ", ", position.y)
	
	move_speed = 30 + 2 * Global.round_number
	health = 2 * Global.round_number
	
	if Global.can_see_enemy_health:
		$HealthLabel.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# chase player
	var player_pos = get_parent().player_position
	var direction = (player_pos - position).normalized()
	position += direction * move_speed * delta
	
	$HealthLabel.text = str(health)

func _on_Skeleton_area_entered(_area):
	take_damage()
	$DamageTimer.start()


func take_damage():
	blink_red()
	health -= Global.get_attack_damage()
	if health <= 0:
		self.queue_free()


func _on_Skeleton_area_exited(_area):
	$DamageTimer.stop()


func _on_DamageTimer_timeout():
	take_damage()
	$DamageTimer.start()


func blink_red():
	self.modulate = "ff0000"
	$BlinkTimer.start()

func _on_BlinkTimer_timeout():
	self.modulate = "ffffff"
