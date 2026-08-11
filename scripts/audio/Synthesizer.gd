extends Node

export(float) var sample_hz = 11025.0

var Instrument = preload("res://scripts/audio/Instrument.gd")
var SquareInstrument = preload("res://scripts/audio/SquareInstrument.gd")
var SineInstrument = preload("res://scripts/audio/SineInstrument.gd")
var OctaveSquareInstrument = preload("res://scripts/audio/OctaveSquareInstrument.gd")
var ChordSineInstrument = preload("res://scripts/audio/ChordSineInstrument.gd")

var playback: AudioStreamPlayback = null
var instruments = []


func _ready():
	var generator = AudioStreamGenerator.new()
	generator.mix_rate = sample_hz

	$AudioStreamPlayer.stream = generator
	$AudioStreamPlayer.play()

	playback = $AudioStreamPlayer.get_stream_playback()

	var bass = OctaveSquareInstrument.new()
	bass.frequency = 55.0
	bass.volume = 0

	var chord = ChordSineInstrument.new()
	chord.frequency = 220.0
	chord.volume = 0.4
	chord.set_chord_type("Dim")
	instruments.append(bass)
	instruments.append(chord)

	_fill_buffer()


func _process(_delta):
	_fill_buffer()


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
