extends Node


# Properties
var available :Array = []	# The available players.
var queue :Array = []		# The queue of sounds to play.
var num_players :int = 8	# The total number of sound players.
var bus :String = "master"	# Bus type


# Creates the avaialble pool of AudioStreamPlayer nodes.
func _ready():
	for i in num_players:
		var p = AudioStreamPlayer.new()
		p.volume_db = -15
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus


# When finished playing a stream, makes the player available again.
func _on_stream_finished(stream):
	available.append(stream)


# Adds the sound_path to the queue of sounds to play.
func play(sound_path):
	queue.append(sound_path)


# Play a queued sound if any players are available.
func _process(_delta):
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
