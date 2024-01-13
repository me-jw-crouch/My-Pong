extends Node

signal score_changed()

@export_category("Game Options")
@export_range(1, 2) var side := 1
@export var min_ball_speed : int = 400
@export var max_ball_speed : int = 2000

var left_score : int = 0
var right_score : int = 0

var player_paddle : Node2D
var ai_paddle : Node2D
var ball : Node2D
var ball_on_board = true

var minY: float = 130  # Minimum Y position for the paddle
var maxY: float = 570  # Maximum Y position for the paddle

func _ready() -> void:
	ball = %Ball
	if side == 2:
		player_paddle = %Paddle2
		ai_paddle = %Paddle1
	else:
		player_paddle = %Paddle1
		ai_paddle = %Paddle2
	ai_paddle.is_AI = true

func _physics_process(_delta: float) -> void:
	ai_paddle.move_towards_ball(ball.position, _delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_y = clamp(event.position.y, minY, maxY)
		player_paddle.position.y = new_y

func _on_bottom_body_entered(body: Node2D) -> void:
	if body == ball:
		body.velocity.y *= -1
		AudioManager.play("res://Sounds/wall_hit.wav")

func _on_top_body_entered(body: Node2D) -> void:
	if body == ball:
		body.velocity.y *= -1
		AudioManager.play("res://Sounds/wall_hit.wav")

func _on_left_body_entered(body: Node2D) -> void:
	if body == ball:
		right_score = score_and_reset(body, right_score)
		score_changed.emit()
		AudioManager.play("res://Sounds/ai_point.wav")

func _on_right_body_entered(body: Node2D) -> void:
	if body == ball:
		left_score = score_and_reset(body, left_score)
		score_changed.emit()
		AudioManager.play("res://Sounds/player_point.wav")

func score_and_reset(body: Node2D, score):
	score += 1
	ball.reset_ball()
	return score

func _on_paddle_bounce(paddle, _ball) -> void:
	_ball.velocity.x *= -1
	_ball.speed = clamp(_ball.speed * 1.1, min_ball_speed, max_ball_speed)
	AudioManager.play("res://Sounds/paddle_hit.wav")
