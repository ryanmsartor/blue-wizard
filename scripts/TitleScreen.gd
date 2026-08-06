extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_pause(true)
	Global.load_high_score()
	$ScoreLabel.text = "High Score: " + str(Global.high_score)
	$StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_StartButton_pressed():
	get_tree().set_pause(false)
	self.queue_free()
