extends "res://scripts/audio/ChordalInstrument.gd"

func generate_sample(sample_hz):
	var sample = 0.0
	
	for i in range(chord_ratios.size()):
		sample += sin(phases[i] * TAU)
		
		phases[i] = fmod(
			phases[i] + (frequency * chord_ratios[i]) / sample_hz,
			1.0
		)
	return sample / float(chord_ratios.size()) * volume * get_envelope_volume(sample_hz)
