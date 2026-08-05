extends Panel

const str_heal		: String = "Heal up to level"
const str_move_spd	: String = "Increase movement speed"
const str_proj_spd	: String = "Increase projectile speed"
const str_atk_spd	: String = "Increase fire rate"
const str_num_proj	: String = "Increase number of fireballs"
const str_atk_pow	: String = "Increase damage dealt"
const str_iframes	: String = "Lengthen invincibility after getting hit"
const str_pierce	: String = "Attacks pierce through enemies"
const str_scan		: String = "See enemy health remaining"
const str_mult		: String = "Gain 20% more points per kill"

var possible_upgrades: Array = []
var selected_upgrades: Array = []


# Called when the node enters the scene tree for the first time.
func _ready():
	print("Upgrade UI ready")
	Global.print_player_stats()
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
		possible_upgrades.append(str_heal)
	if Global.move_speed_boost < 15:
		possible_upgrades.append(str_move_spd)
	if Global.projectile_speed_boost < 15:
		possible_upgrades.append(str_proj_spd)
	if Global.attack_speed_boost < 15:
		possible_upgrades.append(str_atk_spd)
	if Global.num_extra_projectiles < 15:
		possible_upgrades.append(str_num_proj)
	if Global.damage_boost < 15:
		possible_upgrades.append(str_atk_pow)
	if Global.invincibility_time_boost < 15:
		possible_upgrades.append(str_iframes)
	if Global.attacks_pierce == false:
		possible_upgrades.append(str_pierce)
	if Global.can_see_enemy_health == false:
		possible_upgrades.append(str_scan)
	if Global.score_mult < 15:
		possible_upgrades.append(str_mult)

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
		str_heal:
			Global.health = Global.round_number
		str_move_spd:
			Global.move_speed_boost += 1
		str_proj_spd:
			Global.projectile_speed_boost += 1
		str_atk_spd:
			Global.attack_speed_boost += 1
		str_num_proj:
			Global.num_extra_projectiles += 1
		str_atk_pow:
			Global.damage_boost += 1
		str_iframes:
			Global.invincibility_time_boost += 1
		str_pierce:
			Global.attacks_pierce = true
		str_scan:
			Global.can_see_enemy_health = true
		str_mult:
			Global.score_mult += 1
	print("Selected ", button_text)
	Global.print_player_stats()
	get_tree().set_pause(false)
	self.queue_free()



func _on_Button1_pressed():
	print("Button 1 pressed")
	act_on_button($VBoxContainer/Button1.text)

func _on_Button2_pressed():
	print("Button 2 pressed")
	act_on_button($VBoxContainer/Button2.text)

func _on_Button3_pressed():
	print("Button 3 pressed")
	act_on_button($VBoxContainer/Button3.text)
