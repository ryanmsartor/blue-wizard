extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_pause(true)
	$GridContainer/MoveSpeedLabel.text = "Move Speed: " + str(Global.calculate_move_speed()) + "\n"
	$GridContainer/StunLabel.text = "Stun Time: " + str(Global.attack_stun_time) + "\n"
	$GridContainer/ProjectileSpeedLabel.text = "Projectile Speed: " + str(Global.projectile_speed_boost) + "\n"
	$GridContainer/NumProjectilesLabel.text = "Projectiles: " + str(Global.num_extra_projectiles + 1) + "\n"
	$GridContainer/AttackSpeedLabel.text = "Shots Per Second: " + "%.2f" % Global.calculate_shots_per_second() + "\n"
	$GridContainer/AttackPowerLabel.text = "Attack Power: " + str(Global.damage_boost) + "\n"
	$GridContainer/InvincibilityLabel.text = "Invulnerability: " + str(Global.invincibility_time_boost) + "\n"
	$GridContainer/ScoreMultLabel.text = "Score Mult: " + str(Global.calculate_true_score_mult()) + "\n"
	$GridContainer/PierceLabel.visible = Global.attacks_pierce
	$GridContainer/ScanLabel.visible = Global.can_see_enemy_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		get_tree().set_pause(false)
		self.queue_free()
