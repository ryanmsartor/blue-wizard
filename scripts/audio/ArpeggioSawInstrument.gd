extends "res://scripts/audio/ChordalInstrument.gd"

var chosen_frequency: float = 440.0


func choose_new_note():
	chosen_frequency = chord_ratios[randi() % chord_ratios.size()] * frequency

func trigger():
	envelope_position = 0.0
	envelope_active = true
	choose_new_note()

func generate_sample(sample_hz):
	var sample = 2.0 * phase - 1.0
	phase = fmod(phase + (chosen_frequency / 2) / sample_hz, 1.0)
	return sample * volume * get_envelope_volume(sample_hz)
