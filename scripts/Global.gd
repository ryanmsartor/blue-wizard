extends Node

# character stats able to be boosted - all range from 0 to 15
var move_speed_boost 		: float = 0.0
var projectile_speed_boost 	: float = 0.0
var attack_speed_boost		: float = 0.0
var num_extra_projectiles	: int = 0
#var dash_distance			: int = 0
var damage_boost			: int = 0
var invincibility_time_boost: float = 0.0
var score_mult				: float = 0.0

# boolean perks
var attacks_pierce			: bool = false
var can_see_enemy_health	: bool = true

# start with 5 health, gain 1 each level.
var health					: int = 5
var round_number			: int = 1
var score					: int = 0

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func get_attack_damage():
	return 1 + damage_boost * (damage_boost + 1) / 2
	

func print_player_stats():
	print("------PLAYER STATS------")
	print("move speed: ", move_speed_boost)
	print("projectile speed: ", projectile_speed_boost)
	print("attack speed: ", attack_speed_boost)
	print("extra projectiles: ", num_extra_projectiles)
	print("damage boost: ", damage_boost)
	print("invincibility time: ", invincibility_time_boost)
	print("piercing: ", str(attacks_pierce))
	print("see enemy health: ", str(can_see_enemy_health))
	print("score mult: ", score_mult)
