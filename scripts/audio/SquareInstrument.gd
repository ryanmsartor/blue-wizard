extends "res://scripts/audio/Instrument.gd"

var pulse_width = 0.5

func generate_sample(sample_hz):
	var sample = 1.0 if phase > pulse_width else -1.0
	phase = fmod(phase + frequency / sample_hz, 1.0)
	return sample * volume
