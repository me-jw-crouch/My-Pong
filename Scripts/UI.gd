extends Control

var GM


func _ready() -> void:
	GM = $".."

func _on_game_manager_score_changed() -> void:
	$LeftScore.text = str(GM.left_score)
	$RightScore.text = str(GM.right_score)
