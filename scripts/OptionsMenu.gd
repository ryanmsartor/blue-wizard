extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$VerticalContainer/BGMSlider.grab_focus()
	$VerticalContainer/BGMSlider.value = Synthesizer.bgm_volume

func _on_BGMSlider_value_changed(value):
	Synthesizer.bgm_volume = $VerticalContainer/BGMSlider.value


func _on_AcceptButton_pressed():
	save_bgm_volume()
	get_parent().get_node("StartButton").visible = true
	get_parent().get_node("OptionsButton").visible = true
	get_parent().get_node("OptionsButton").grab_focus()
	self.queue_free()



func save_bgm_volume():
	var file = File.new()
	file.open("user://bgm_volume.dat", File.WRITE)
	file.store_var(Synthesizer.bgm_volume)
	file.close()
	
