extends "res://scripts/audio/Instrument.gd"

func generate_sample(sample_hz):
	var sample = rand_range(-1.0, 1.0)
	return sample * volume * get_envelope_volume(sample_hz)

func _on_subdivision():
	pass
