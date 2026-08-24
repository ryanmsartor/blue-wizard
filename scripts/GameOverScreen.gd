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
	Synthesizer.song_position = 0
	$EighthNoteTimer.wait_time = get_parent().get_node("SpawnTimer").wait_time / 2
	$EighthNoteTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartButton_pressed():
	$EighthNoteTimer.stop()
	get_tree().set_pause(false)
	Global.reset_state()
	self.queue_free()
	get_tree().reload_current_scene()


func _on_EighthNoteTimer_timeout():
	
	Synthesizer.bass.trigger()
	Synthesizer.peggi.trigger()

	if Synthesizer.song_position % 2 == 0:
		Synthesizer.hat.trigger()
		Synthesizer.chord.trigger()
		
	Synthesizer.advance_song(Synthesizer.title_theme, $EighthNoteTimer.wait_time)
