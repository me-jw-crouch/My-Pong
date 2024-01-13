class_name Ball
extends CharacterBody2D

const STARTING_SPEED :float = 400.0
const STARTING_POS :Vector2 = Vector2(566, 342)
var speed :float


func _ready() -> void:
	reset_ball()


func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta * speed)


func reset_ball():
	if randi() % 2 == 1:
		velocity = Vector2(randf_range(-1, -.5), randf_range(-1, 1))
	else:
		velocity = Vector2(randf_range(1, .5), randf_range(-1, 1))
	speed = STARTING_SPEED
	position = STARTING_POS
