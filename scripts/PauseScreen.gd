extends Panel


export (PackedScene) var menu_scene


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_pause(true)
	$GridContainer/MoveSpeedLabel.text = "Move Speed: " + str(Global.calculate_move_speed()) + "\n"
	$GridContainer/StunLabel.text = "Stun Time: " + str(0.2 * Global.attack_stun_time) + "\n"
	$GridContainer/ProjectileSpeedLabel.text = "Projectile Speed: " + str(128 * ( 1.0 + ( Global.projectile_speed_boost / 10.0))) + "\n"
	$GridContainer/NumProjectilesLabel.text = "Projectiles: " + str(Global.num_extra_projectiles + 1) + "\n"
	$GridContainer/AttackSpeedLabel.text = "Shots Per Second: " + "%.2f" % Global.calculate_shots_per_second() + "\n"
	$GridContainer/AttackPowerLabel.text = "Attack Power: " + str(Global.get_attack_damage()) + "\n"
	$GridContainer/InvincibilityLabel.text = "Invulnerability: " + str(Global.get_invincibility_duration()) + "\n"
	$GridContainer/ScoreMultLabel.text = "Score Mult: " + "%.2f" % Global.calculate_true_score_mult() + "\n"
	$GridContainer/PierceLabel.visible = Global.attacks_pierce
	$GridContainer/ScanLabel.visible = Global.can_see_enemy_health
	$OptionsButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		get_tree().set_pause(false)
		self.queue_free()


func _on_OptionsButton_pressed():
	var menu = menu_scene.instance()
	menu.rect_position.x = 0
	menu.rect_position.y = 0
	menu.get_stylebox("panel").bg_color = Color(0.113725, 0.05098, 0.352941)
	$StartButton.visible = false
	$OptionsButton.visible = false
	add_child(menu)



func _on_StartButton_pressed():
	get_tree().set_pause(false)
	self.queue_free()
