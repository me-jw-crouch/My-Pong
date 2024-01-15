extends Control

var GM


# Assigns parent so we can grab the scores...
func _ready() -> void:
	GM = $".."


# Handles score UI updates
func _on_game_manager_score_changed() -> void:
	# Should I do this another way... yeah... probably.
	$LeftScore.text = str(GM.left_score)
	$RightScore.text = str(GM.right_score)
