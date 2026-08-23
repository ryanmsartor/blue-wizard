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
	Synthesizer.song_position = 0
	Synthesizer.chord.set_envelope(0.9,4 * $EighthNoteTimer.wait_time,0.1)
	$EighthNoteTimer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_StartButton_pressed():
	$EighthNoteTimer.stop()
	Synthesizer.song_position = 0
	Synthesizer.chord.set_envelope(0.5,2,0.5)
	get_tree().set_pause(false)
	get_parent().get_node("SpawnTimer").start()
	self.queue_free()


func _on_EighthNoteTimer_timeout():
	Synthesizer.bass.trigger()
	
	if Synthesizer.song_position % 2 == 0:
		Synthesizer.hat.trigger()
		
	if Synthesizer.song_position % 4 == 0:
		Synthesizer.chord.trigger()
		
	Synthesizer.advance_song(Synthesizer.title_theme, $EighthNoteTimer.wait_time)
