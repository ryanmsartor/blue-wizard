extends "res://scripts/audio/Instrument.gd"

const root	: float = 1.0
const min3  : float = 6.0 / 5.0
const maj3  : float = 5.0 / 4.0
const dim5  : float = 36.0 / 25.0
const perf5 : float = 3.0 / 2.0
const dim7  : float = 27.0 / 16.0
const min7  : float = 7.0 / 4.0
const maj7  : float = 15.0 / 8.0
const perf8 : float = 2.0
const maj9  : float = 9.0 / 4.0

# default to major chord
var chord_ratios = [
	root,
	maj3,
	perf5,
	perf8
]

func set_chord_type(type: String):
	
	match type:
		"Maj":
			chord_ratios = [
				root,
				maj3,
				perf5,
				perf8
			]
		"Min":
			chord_ratios = [
				root,
				min3,
				perf5,
				perf8
			]
		"Maj7":
			chord_ratios = [
				root,
				maj3,
				perf5,
				maj7
			]
		"Dom7":
			chord_ratios = [
				root,
				maj3,
				perf5,
				min7
			]
		"Min7":
			chord_ratios = [
				root,
				min3,
				perf5,
				min7
			]
		"Dim":
			chord_ratios = [
				root,
				min3,
				dim5,
				perf8
			]
		"Dimbb7":
			chord_ratios = [
				root,
				min3,
				dim5,
				dim7
			]
		"Maj9":
			chord_ratios = [
				root,
				maj3,
				perf5,
				maj9
			]
		"Min9":
			chord_ratios = [
				root,
				min3,
				perf5,
				maj9
			]


func generate_sample(sample_hz):
	var sample = 0.0

	for ratio in chord_ratios:
		sample += sin(fmod(phase * ratio, 1.0) * TAU)

	phase = fmod(phase + frequency / sample_hz, 1.0)

	return sample / float(chord_ratios.size()) * volume
