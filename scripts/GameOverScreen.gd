extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().set_pause(true)
	$HighScoreLabel.text = "High Score: " + str(Global.high_score)
	$FinalScoreLabel.text = "Final Score: " + str(Global.score)
	$StartButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	get_tree().set_pause(false)
	Global.reset_state()
	self.queue_free()
	get_tree().reload_current_scene()
