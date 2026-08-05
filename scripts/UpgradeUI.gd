extends Panel

var possible_upgrades: Array = []
var selected_upgrades: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Upgrade UI ready")
	get_tree().set_pause(true)
	get_possible_upgrades()
	select_3_random_upgrades()
	assign_upgrades_to_buttons()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_possible_upgrades():
	possible_upgrades.clear()
	
	if Global.health < Global.round_number:
		possible_upgrades.append("Heal up to level")
	if Global.move_speed_boost < 15:
		possible_upgrades.append("Increase movement speed")
	if Global.projectile_speed_boost < 15:
		possible_upgrades.append("Increase projectile speed")
	if Global.attack_speed_boost < 15:
		possible_upgrades.append("Increase fire rate")
	if Global.num_extra_projectiles < 15:
		possible_upgrades.append("Increase number of fireballs")
	if Global.damage_boost < 15:
		possible_upgrades.append("Increase damage dealt")
	if Global.invincibility_time_boost < 15:
		possible_upgrades.append("Lengthen invincibility after getting hit")
	if Global.attacks_pierce == false:
		possible_upgrades.append("Attacks pierce through enemies")
	if Global.can_see_enemy_health == false:
		possible_upgrades.append("See enemy health remaining")

func select_3_random_upgrades():
	selected_upgrades.clear()
	possible_upgrades.shuffle()
	for _i in range(0,3):
		selected_upgrades.append(possible_upgrades.pop_back())
	
func assign_upgrades_to_buttons():
	$VBoxContainer/Button1.text = selected_upgrades[0]
	$VBoxContainer/Button2.text = selected_upgrades[1]
	$VBoxContainer/Button3.text = selected_upgrades[2]

func act_on_button(button_text):
	match button_text:
		"Heal up to level":
			Global.health = Global.round_number
		"Increase movement speed":
			Global.move_speed_boost += 1
		"Increase projectile speed":
			Global.projectile_speed_boost += 1
		"Increase fire rate":
			Global.attack_speed_boost += 1
		"Increase number of fireballs":
			Global.num_extra_projectiles += 1
		"Increase damage dealt":
			Global.damage_boost += 1
		"Lengthen invincibility after getting hit":
			Global.invincibility_time_boost += 1
		"Attacks pierce through enemies":
			Global.attacks_pierce = true
		"See enemy health remaining":
			Global.can_see_enemy_health = true
	print("Selected ", button_text)
	get_tree().set_pause(false)
	self.queue_free()





func _on_Button1_pressed():
	print("Button 1 pressed")
	act_on_button($VBoxContainer/Button1.text)

func _on_Button2_pressed():
	print("Button 2 pressed")
	act_on_button($VBoxContainer/Button1.text)

func _on_Button3_pressed():
	print("Button 3 pressed")
	act_on_button($VBoxContainer/Button1.text)
