extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_health_display()
	update_level_display()


func update_health_display():
	$PlayerHealthLabel.text = str(Global.health)

func update_level_display():
	var level = Global.round_number
	$LevelLabel.text = "Level " + str(level)
