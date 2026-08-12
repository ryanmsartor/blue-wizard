extends Reference

var sample_hz:  float = 11025.0
var frequency: 	float = 440.0
var volume: 	float = 1.0
var phase: 		float = 0.0

var envelope_time: float = 1.0
var attack_ratio: float = 0.0
var release_ratio: float = 0.7

var envelope_position: float = 0.0
var envelope_active: bool = false
var use_envelope: bool = true

func trigger():
	envelope_position = 0.0
	envelope_active = true
	

func get_envelope_volume(sample_hz):
	
	if not use_envelope:
		return 1.0
	
	if not envelope_active:
		return 0.0

	var attack_time = envelope_time * attack_ratio
	var release_time = envelope_time * release_ratio
	var hold_time = envelope_time - attack_time - release_time

	var current_time = envelope_position / sample_hz

	var envelope_volume = 1.0

	if current_time < attack_time:
		# Attack
		envelope_volume = current_time / attack_time

	elif current_time < attack_time + hold_time:
		# Hold
		envelope_volume = 1.0

	elif current_time < envelope_time:
		# Release
		var release_position = current_time - attack_time - hold_time
		envelope_volume = 1.0 - (release_position / release_time)

	else:
		# Envelope finished
		envelope_volume = 0.0
		envelope_active = false

	envelope_position += 1.0

	return envelope_volume


# overridden by specific instrument class scripts
func generate_sample(sample_hz):
	return 0.0




func set_envelope(attack, duration, release):
	attack_ratio = clamp(0.0, attack, 1.0)
	envelope_time = duration
	release_ratio = clamp(0.0, release, (1.0 - attack))

func set_volume(vol):
	volume = clamp(vol, 0.0, 1.0)

func set_note(note_name):
	var parts = note_name.split("_")
	var note = parts[0]
	var octave = int(parts[1])

	var note_number = {
		"C": 0,
		"C#": 1,
		"D": 2,
		"D#": 3,
		"E": 4,
		"F": 5,
		"F#": 6,
		"G": 7,
		"G#": 8,
		"A": 9,
		"A#": 10,
		"B": 11
	}

	# MIDI-style note number, where C0 = 12
	var midi_note = (octave + 1) * 12 + note_number[note]

	# A4 is MIDI note 69
	var semitones_from_A4 = midi_note - 69

	frequency = 440.0 * pow(2.0, semitones_from_A4 / 12.0)
	
	
