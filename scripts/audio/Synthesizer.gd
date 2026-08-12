extends Node

export(float) var sample_hz = 11025.0

var Instrument = preload("res://scripts/audio/Instrument.gd")
var ChordalInstrument = preload("res://scripts/audio/ChordalInstrument.gd")

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

var song_position: int = 0

var main_theme = {
	"bassline": [
		"F_2",	"C_2",	"D#_2",	"A_1",
		"B_1",	"C#_2",	"D#_2",	"G_2"
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
	
	chord.set_note(song.chord_notes[song_position])
	chord.set_chord_type(song.chord_types[song_position])
	chord.envelope_time = note_length
	
	peggi.set_note(song.chord_notes[song_position])
	peggi.set_chord_type(song.chord_types[song_position])
	
	song_position += 1
	if song_position >= song.bassline.size():
		song_position = 0

func _ready():
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_hz
	generator.buffer_length = 0.05
	$AudioStreamPlayer.stream = generator
	$AudioStreamPlayer.play()

	playback = $AudioStreamPlayer.get_stream_playback()

	bass = OctaveSquareInstrument.new()
	bass.set_envelope(0.05,2,0.7)
	bass.set_volume(0.2)
	bass.notes_per_beat = 2

	chord = ChordSineInstrument.new()
	chord.set_chord_type("Maj7")
	chord.set_envelope(0.5,2,0.5)
	chord.set_volume(0.5)

	peggi = ArpeggioSawInstrument.new()
	peggi.set_chord_type("Maj7")
	peggi.set_envelope(0.01,0.1,0.9)
	peggi.set_volume(0.2)

	instruments.append(bass)
	instruments.append(chord)
	instruments.append(peggi)

	_fill_buffer()


func _process(_delta):
	print(playback.get_frames_available())
	_fill_buffer()
	print(playback.get_frames_available())

func _fill_buffer():
	var to_fill = min(playback.get_frames_available(), 128)

	while to_fill > 0:
		var sample = 0.0

		for instrument in instruments:
			sample += instrument.generate_sample(sample_hz)

		# Prevent clipping when multiple instruments are playing.
		sample = clamp(sample, -1.0, 1.0)

		playback.push_frame(Vector2.ONE * sample)

		to_fill -= 1
