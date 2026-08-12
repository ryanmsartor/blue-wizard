extends "res://scripts/audio/Instrument.gd"

func generate_sample(sample_hz):
	var sample = sin(phase * TAU)
	phase = fmod(phase + frequency / sample_hz, 1.0)
	return sample * volume * get_envelope_volume(sample_hz)
