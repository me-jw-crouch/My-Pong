extends Area2D

signal on_bounce()

@export_range(0.0, 1.0, .05) var accuracy = 1.0

@onready var ball = get_parent().get_node("Ball")
@onready var GM = get_parent()

var last_position : Vector2
var velocity := Vector2.ZERO
var is_AI = false
var speed = 1

var minY: float = 130  # Minimum Y position for the paddle
var maxY: float = 570  # Maximum Y position for the paddle

func _ready() -> void:
	last_position = position

func _physics_process(delta: float) -> void:
	velocity = (last_position - position) * delta
	last_position = position

func _on_paddle_bounce(_ball: Area2D):
	on_bounce.emit(self, _ball.get_parent())

func move_towards_ball(_position: Vector2, delta: float):
	var distance = (_position.y - position.y) * delta
	distance *= accuracy
	position.y = clamp(position.y + distance, minY, maxY)
