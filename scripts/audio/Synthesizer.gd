extends Node

export(float) var sample_hz = 11025.0

var Instrument = preload("res://scripts/audio/Instrument.gd")
var ChordalInstrument = preload("res://scripts/audio/ChordalInstrument.gd")

var NoiseInstrument = preload("res://scripts/audio/NoiseInstrument.gd")
var SineInstrument = preload("res://scripts/audio/SineInstrument.gd")
var SquareInstrument = preload("res://scripts/audio/SquareInstrument.gd")
var SawInstrument = preload("res://scripts/audio/SawInstrument.gd")
var TriangleInstrument = preload("res://scripts/audio/TriangleInstrument.gd")

var OctaveSquareInstrument = preload("res://scripts/audio/OctaveSquareInstrument.gd")
var ChordSineInstrument = preload("res://scripts/audio/ChordSineInstrument.gd")
var ArpeggioSawInstrument = preload("res://scripts/audio/ArpeggioSawInstrument.gd")


var playback: AudioStreamPlayback = null
var instruments = []

var bass
var chord
var peggi
var hat

var song_position: int = 0

var main_theme = {
	"bassline": [
		"F_2",	"C_2",	"D#_2",	"A_1",
		"B_1",	"C#_2",	"D#_2",	"G_2",
		"F_2",	"C_2",	"D#_2",	"A_1",
		"B_1",	"C#_2",	"D#_2",	"G_2",
		"F_2",	"C_2",	"D#_2",	"A_1",
		"A#_1",	"A_1",	"G#_1",	"G_1",
		"F_2",	"F_2",	"D#_2", "D#_2",
		"C#_2", "C#_2", "C_2",	"C_2"
	],
	"bass_divisions": [
		1, 1, 1, 1,	1, 1, 1, 1,
		2, 1, 2, 1,	4, 2, 2, 1,
		2, 2, 2, 2,	4, 4, 4, 1,
		1, 1, 1, 2,	1, 2, 1, 2
	],
	"bass_embellishments": [
		"F_3",	"C_3",	"D#_3",	"A_2",
		"B_2",	"C#_3",	"D#_3",	"G_3",
		"F_3",	"C_3",	"D#_3",	"A_2",
		"B_2",	"C#_3",	"D#_3",	"G_3",
		"F_3",	"C_3",	"D#_3",	"A_2",
		"A#_2",	"A_2",	"G#_2",	"G_2",
		"F_3",	"F_3",	"D#_3", "D#_3",
		"C#_3", "C#_3", "C_3",	"C_3"
	],
	"chord_notes": [
		"F_4",	"F_4",	"D#_4",	"A_3",
		"B_3",	"A_3",	"G#_3",	"G_3"	
	],
	"chord_types": [
		"Maj7",	"Min7",	"Maj7",	"Maj9",
		"Min7",	"Maj9",	"Maj9",	"Maj9"
	]
}

func advance_song(song, note_length):
	bass.set_note(song.bassline[song_position])
	bass.envelope_time = note_length
	bass.notes_per_beat = song.bass_divisions[song_position % song.bass_divisions.size()]
	
	chord.set_note(song.chord_notes[song_position % song.chord_notes.size()])
	chord.set_chord_type(song.chord_types[song_position % song.chord_types.size()])
	chord.envelope_time = note_length
	
	peggi.set_note(song.chord_notes[song_position % song.chord_notes.size()])
	peggi.set_chord_type(song.chord_types[song_position % song.chord_types.size()])
	
	song_position += 1
	song_position %= song.bassline.size()

func _ready():
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_hz
	generator.buffer_length = 0.1
	$AudioStreamPlayer.stream = generator
	$AudioStreamPlayer.play()

	playback = $AudioStreamPlayer.get_stream_playback()

	bass = OctaveSquareInstrument.new()
	bass.set_envelope(0.05,2,0.7)
	bass.set_volume(0.175)
	bass.notes_per_beat = 2

	chord = ChordSineInstrument.new()
	chord.set_chord_type("Maj7")
	chord.set_envelope(0.5,2,0.5)
	chord.set_volume(0.5)

	peggi = ArpeggioSawInstrument.new()
	peggi.set_chord_type("Maj7")
	peggi.set_envelope(0.01,0.15,0.9)
	peggi.set_volume(0.2)
	
	hat = NoiseInstrument.new()
	hat.set_envelope(0,0.02,0.1)
	hat.set_volume(0.1)

	instruments.append(bass)
	instruments.append(chord)
	instruments.append(peggi)
	instruments.append(hat)

	_fill_buffer()


func _process(_delta):
	_fill_buffer()

func _fill_buffer():
	var to_fill = min(playback.get_frames_available(), 256)

	while to_fill > 0:
		var sample = 0.0

		for instrument in instruments:
			sample += instrument.generate_sample(sample_hz)

		# Prevent clipping when multiple instruments are playing.
		sample = clamp(sample, -1.0, 1.0)

		playback.push_frame(Vector2.ONE * sample)

		to_fill -= 1
