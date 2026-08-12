extends Node

export(float) var sample_hz = 11025.0

var Instrument = preload("res://scripts/audio/Instrument.gd")

var SquareInstrument = preload("res://scripts/audio/SquareInstrument.gd")
var SineInstrument = preload("res://scripts/audio/SineInstrument.gd")
var SawInstrument = preload("res://scripts/audio/SawInstrument.gd")
var TriangleInstrument = preload("res://scripts/audio/TriangleInstrument.gd")

var OctaveSquareInstrument = preload("res://scripts/audio/OctaveSquareInstrument.gd")
var ChordSineInstrument = preload("res://scripts/audio/ChordSineInstrument.gd")


var playback: AudioStreamPlayback = null
var instruments = []

var bass
var chord


var main_bassline = [
	"F_2",
	"C_2",
	"D#_2",
	"A_1"
]

var main_chord_notes = [
	"F_4",
	"F_4",
	"D#_4",
	"A_3"
]

var main_chord_types = [
	"Maj7",
	"Min7",
	"Dom7",
	"Maj9"
]


func _ready():
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_hz
	generator.buffer_length = 0.05
	$AudioStreamPlayer.stream = generator
	$AudioStreamPlayer.play()

	playback = $AudioStreamPlayer.get_stream_playback()

	bass = OctaveSquareInstrument.new()
	bass.set_note("F_2")
	bass.set_envelope(0.05,1.9,0.7)
	bass.set_volume(0.2)

	chord = ChordSineInstrument.new()
	chord.set_note("F_4")
	chord.set_envelope(0.5,2,0.5)
	chord.set_volume(0.5)
	chord.set_chord_type("Dom7")
	instruments.append(bass)
	instruments.append(chord)

	_fill_buffer()


func _process(_delta):
	print(playback.get_frames_available())
	_fill_buffer()
	print(playback.get_frames_available())

func _fill_buffer():
	var to_fill = playback.get_frames_available()

	while to_fill > 0:
		var sample = 0.0

		for instrument in instruments:
			sample += instrument.generate_sample(sample_hz)

		# Prevent clipping when multiple instruments are playing.
		sample = clamp(sample, -1.0, 1.0)

		playback.push_frame(Vector2.ONE * sample)

		to_fill -= 1
