extends "res://scripts/audio/Instrument.gd"

var pulse_width = 0.5
var octave_mix = 0.5

func generate_sample(sample_hz):
	var sample = 1.0 if phase >= pulse_width else -1.0
	var phase2 = fmod(phase * 2.0, 1.0)
	var sample2 = 1.0 if phase2 >= pulse_width else -1.0

	phase = fmod(phase + frequency / sample_hz,	1.0)

	return (
		(sample * (1.0 - octave_mix)) +
		(sample2 * octave_mix)
	) * volume * get_envelope_volume(sample_hz)
