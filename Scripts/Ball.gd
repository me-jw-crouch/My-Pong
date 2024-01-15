class_name Ball
extends CharacterBody2D
# Declares the Ball class, extending the CharacterBody2D class,
# which provides physics-based behaviors suitable for character-like entities.

# Constant values for the ball's starting speed and position.
const STARTING_SPEED :float = 400.0
const STARTING_POS :Vector2 = Vector2(566, 342)

# Variable to store the current speed of the ball.
var speed :float


# Called when the node is added to the scene. Initializes the ball by
# resetting its position and speed.
func _ready() -> void:
	reset_ball()


# Called every physics frame. Moves the ball based on its velocity and current
# speed, adjusted by the delta time.
func _physics_process(delta: float) -> void:
	move_and_collide(velocity * delta * speed)


# Resets the ball to its starting state. Randomly determines the initial
# direction and sets the speed and position to the starting values.
func reset_ball():
	# Randomly choose a direction for the ball to start moving in.
	# The velocity's x-component is either left or right, and the
	# y-component is up or down.
	if randi() % 2 == 1:
		velocity = Vector2(randf_range(-1, -.5), randf_range(-1, 1))
	else:
		velocity = Vector2(randf_range(1, .5), randf_range(-1, 1))
	speed = STARTING_SPEED
	position = STARTING_POS
