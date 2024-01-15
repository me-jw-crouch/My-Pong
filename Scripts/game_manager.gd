extends Node

## Signal to tell the UI to update.
signal score_changed()

# Properties
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
var midY: float = ((maxY-minY)/2) + minY

# Sets up variables to appropriate nodes and sets AI.
# Allows player to be either side but default is player on left.
func _ready() -> void:
	ball = %Ball
	if side == 2:
		player_paddle = %Paddle2
		ai_paddle = %Paddle1
	else:
		player_paddle = %Paddle1
		ai_paddle = %Paddle2
	ai_paddle.is_AI = true


# Tell's the AI Paddle to move during physics updates.
func _physics_process(_delta: float) -> void:
	if ball.position.x < 566:
		ai_paddle.move_towards_pos(midY, _delta)
	else:
		ai_paddle.move_towards_pos(ball.position.y, _delta)


# Any unhandled mouse movement is grabbed and used to adjust the player paddle.
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var new_y = clamp(event.position.y, minY, maxY)
		player_paddle.position.y = new_y


# Bounces the ball when it hits the bottom wall.
func _on_bottom_body_entered(body: Node2D) -> void:
	if body == ball:
		body.velocity.y *= -1
		AudioManager.play("res://Sounds/wall_hit.wav")


# Bounces the ball when it hits the top wall.
func _on_top_body_entered(body: Node2D) -> void:
	if body == ball:
		body.velocity.y *= -1
		AudioManager.play("res://Sounds/wall_hit.wav")


# Player 2 scores: Reset state, update score and UI, and play sound.
func _on_left_body_entered(body: Node2D) -> void:
	if body == ball:
		right_score = score_and_reset(body, right_score)
		score_changed.emit()
		AudioManager.play("res://Sounds/ai_point.wav")


# Player 1 scores: Reset state, update score and UI, and play sound.
func _on_right_body_entered(body: Node2D) -> void:
	if body == ball:
		left_score = score_and_reset(body, left_score)
		score_changed.emit()
		AudioManager.play("res://Sounds/player_point.wav")


# Updates appropriate score, reset ball, return score for updating.
func score_and_reset(_ball: Node2D, score):
	score += 1
	ball.reset_ball()
	return score


# Bounces the ball off of a paddle. Currently paddle is unused, may use it's
# velocity to change direction, angle, or speed, idk.
func _on_paddle_bounce(_paddle, _ball) -> void:
	_ball.velocity.x *= -1
	_ball.speed = clamp(_ball.speed * 1.1, min_ball_speed, max_ball_speed)
	AudioManager.play("res://Sounds/paddle_hit.wav")
