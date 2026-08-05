extends Node2D

export (PackedScene) var skeleton_scene
export (PackedScene) var upgrade_scene

var screen_size			: Vector2
var player_position		: Vector2
var max_enemies_onscreen: int = 0
var num_enemies_left	: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	$SpawnTimer.start()
	start_round()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# enemies need to know this in order to chase you
	player_position = $Player.position
	
	if Global.health < 0:
		pass # put game over stuff here


func start_round():
	max_enemies_onscreen = get_max_num_enemies_onscreen()
	num_enemies_left = get_num_enemies_in_round()
	print("-----starting round ", Global.round_number,"-----")
	print("max enemies onscreen: ", max_enemies_onscreen)
	print("total enemies in round: ", num_enemies_left)
	
func _on_SpawnTimer_timeout():
	var skellies_onscreen = get_num_skeletons()
	# print("skellies onscreen: ", skellies_onscreen)
	if num_enemies_left <= 0 and skellies_onscreen <= 0:
		end_round()	
	if skellies_onscreen < max_enemies_onscreen and num_enemies_left > 0:
		spawn_skeleton()
		num_enemies_left -= 1
	# print("skellies left to spawn: ", num_enemies_left)
	
func end_round():
	Global.round_number += 1
	Global.health += 1
	add_child(upgrade_scene.instance())
	start_round()




func spawn_skeleton():
	var skelly = skeleton_scene.instance()
	var edge = get_random_edge()
	if edge == 0:
		skelly.position.x = 0
		skelly.position.y = get_random_y_coord()
	elif edge == 1:
		skelly.position.x = screen_size.x
		skelly.position.y = get_random_y_coord()
	elif edge == 2:
		skelly.position.y = 0
		skelly.position.x = get_random_y_coord()
	else: # edge == 3
		skelly.position.y = screen_size.y
		skelly.position.x = get_random_y_coord()

	add_child(skelly)
	
func get_random_edge():
	return randi() % 4
	
func get_random_x_coord():
	return randi() % int(get_viewport_rect().size.x)

func get_random_y_coord():
	return randi() % int(get_viewport_rect().size.y)
	
	
	
func get_max_num_enemies_onscreen():
	return int(1 + (0.55 * Global.round_number))
	
func get_num_enemies_in_round():
	return 1 + int(1.6 * Global.round_number)

func get_num_skeletons():
	var count = 0
	for child in get_children():
		if "Skeleton" in child.name:
			count += 1
	return count
