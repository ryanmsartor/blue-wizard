extends ColorRect

export (PackedScene) var menu_scene

func _ready():
	get_tree().set_pause(true)
	Global.load_high_score()
	$ScoreLabel.text = "High Score: " + str(Global.high_score)
	$StartButton.grab_focus()
	Synthesizer.song_position = 0
	Synthesizer.chord.set_envelope(0.9,4 * $EighthNoteTimer.wait_time,0.1)
	$EighthNoteTimer.start()



func _on_EighthNoteTimer_timeout():
	Synthesizer.bass.trigger()
	
	if Synthesizer.song_position % 2 == 0:
		Synthesizer.hat.trigger()
		
	if Synthesizer.song_position % 4 == 0:
		Synthesizer.chord.trigger()
		
	Synthesizer.advance_song(Synthesizer.title_theme, $EighthNoteTimer.wait_time)



func _on_StartButton_pressed():
	$EighthNoteTimer.stop()
	Synthesizer.song_position = 0
	Synthesizer.chord.set_envelope(0.5,2,0.5)
	get_tree().set_pause(false)
	get_parent().get_node("SpawnTimer").start()
	self.queue_free()






func _on_OptionsButton_pressed():
	$StartButton.visible = false
	$OptionsButton.visible = false
	add_child(menu_scene.instance())
