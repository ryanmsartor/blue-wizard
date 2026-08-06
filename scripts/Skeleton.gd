extends Area2D

var move_speed: int
var health: int
var is_stunned: bool = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	print("Skeleton spawned at ", position.x, ", ", position.y)
	
	move_speed = 30 + 2 * Global.round_number
	health = int(2.1 * Global.round_number)
	if Global.can_see_enemy_health:
		$HealthLabel.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# chase player
	var player_pos = get_parent().player_position
	var direction = (player_pos - position).normalized()
	if not is_stunned:
		position += direction * move_speed * delta
	
	$HealthLabel.text = str(health)

func _on_Skeleton_area_entered(_area):
	take_damage()
	$DamageTimer.start()


func take_damage():
	blink_red()
	health -= Global.get_attack_damage()
	if Global.attack_stun_time > 0:
		$StunTimer.set_wait_time(0.2 * Global.attack_stun_time)
		$StunTimer.start()
		is_stunned = true
	if health <= 0:
		Global.score += int(Global.round_number * 100 * pow(1.2,Global.score_mult))
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


func _on_StunTimer_timeout():
	is_stunned = false
