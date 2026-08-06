extends Area2D


const base_move_speed = 64

export(PackedScene) var fireball_scene

var can_attack = true # interacts with $AttackCooldown timer
var can_take_damage = true


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	animate_player()
	move_player(delta)
	
	if can_attack == true:
		if Input.is_action_pressed("ui_accept"):
			attack()


func animate_player():
	$AnimatedSprite.speed_scale = 4
	if Input.is_action_pressed("move_up"):
		$AnimatedSprite.animation = "up"
	elif Input.is_action_pressed("move_down"):
		$AnimatedSprite.animation = "down"
	elif Input.is_action_pressed("move_left"):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = true
	elif Input.is_action_pressed("move_right"):
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.speed_scale = 1
	
func move_player(dt):
	var input_vector = Input.get_vector(
		"move_left",
		"move_right",
		"move_up",
		"move_down"
	)
	input_vector = input_vector * base_move_speed * ( 1.0 + ( Global.move_speed_boost / 10.0 ))
	position += input_vector * dt
	position.x = clamp(position.x, 0, get_parent().screen_size.x)
	position.y = clamp(position.y, 0, get_parent().screen_size.y)

func attack():
	
	can_attack = false
	$AttackCooldown.set_wait_time( 0.5 * ( 1.0 - (Global.attack_speed_boost / 20.0)) )
	$AttackCooldown.start()
	
	for i in range(0, Global.num_extra_projectiles + 1):
		fire_projectile(i)
		

func fire_projectile(num_extras):
	var projectile = fireball_scene.instance()
	projectile.position = position
	projectile.speed *= ( 1.0 + ( Global.projectile_speed_boost / 10.0))
	
	if Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):	# up right
		projectile.rotation = PI / 4
		projectile.position.y -= 4
		projectile.position.x += 8
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"): # down right
		projectile.rotation = 3 * PI / 4
		projectile.position.y += 12
		projectile.position.x += 8
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"): # down left
		projectile.rotation = 5 * PI / 4
		projectile.position.y += 12
		projectile.position.x -= 8
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"): # up left
		projectile.rotation = 7 * PI / 4
		projectile.position.y -= 4
		projectile.position.x -= 8
	elif $AnimatedSprite.animation == "up":		# up
		projectile.rotation = 0
		projectile.position.y -= 12
	elif $AnimatedSprite.animation == "down":	# down
		projectile.rotation = PI
		projectile.position.y += 12
	elif $AnimatedSprite.animation == "right":
		projectile.position.y += 4
		if $AnimatedSprite.flip_h: 				# left
			projectile.rotation = 3 * PI / 2
			projectile.position.x -= 12
		else: 									# right
			projectile.rotation = PI / 2
			projectile.position.x += 12
	
	# add spread for extra projectiles
	projectile.rotation += (num_extras *(rand_range(PI/-24, PI/24) ) )
	
	get_parent().add_child(projectile)

func _on_AttackCooldown_timeout():
	can_attack = true


func _on_Player_area_entered(_area):
	if can_take_damage:
		can_take_damage = false
		take_damage()
	$DamageTimer.set_wait_time(get_invincibility_duration())
	$DamageTimer.start()

func take_damage():
	blink_red()
	Global.health -= 1
	Global.score -= 10 * Global.round_number
	$InvincibilityTimer.set_wait_time(get_invincibility_duration())
	$InvincibilityTimer.start()

func blink_red():
	modulate = "ff0000"
	$BlinkTimer.start()
	
func _on_BlinkTimer_timeout():
	modulate = "4444aa"			# now we blue


func _on_DamageTimer_timeout():
	if can_take_damage:
		can_take_damage = false
		take_damage()
	

func _on_InvincibilityTimer_timeout():
	can_take_damage = true
	modulate = "ffffff"			# return to normal color


func _on_Player_area_exited(_area):
	$DamageTimer.stop()


func get_invincibility_duration():
	return (0.25 + (0.075 * Global.invincibility_time_boost))
