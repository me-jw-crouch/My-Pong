extends Area2D

# Emits signal when ball hits paddle. The Game Manager (GM) can listen to
# this signal to update the ball's velocity or other game mechanics.
signal on_bounce()

# Properties
# The accuracy of the AI's movement towards the ball.
# Ranges from 0.0 (no movement) to 1.0 (direct movement towards the ball).
@export_range(0.0, 1.0, .05) var accuracy = 1.0

# Stores the paddle's last position. Used for calculating velocity.
var last_position : Vector2

# Current velocity of the paddle. Calculated each frame based on movement.
var velocity := Vector2.ZERO

# Flag to indicate if the paddle is controlled by AI.
var is_AI :bool = false

# Speed factor for the paddle's movement.
var speed = 1

# Minimum and maximum Y positions for the paddle to constrain its movement
# within these bounds.
var minY: float = 130
var maxY: float = 570
var midY: float = ((maxY-minY)/2) + minY

# References to the ball and the Game Manager (GM) nodes for interaction
# purposes.
@onready var ball = get_parent().get_node("Ball")
@onready var GM = get_parent()


# Called when the node is added to the scene. Initializes the last_position
# variable.
func _ready() -> void:
	last_position = position


# Called every physics frame. Updates the velocity based on the paddle's
# movement and stores the current position for the next frame.
func _physics_process(delta: float) -> void:
	velocity = (last_position - position) * delta
	last_position = position


# Called when the paddle collides with the ball.
# Emits the on_bounce signal with the paddle and ball as arguments.
func _on_paddle_bounce(_ball: Area2D):
	on_bounce.emit(self, _ball.get_parent())

# Moves the paddle towards the ball's Y position, adjusted by the accuracy
# factor. Ensures the paddle stays within its allowed Y position range.
func move_towards_pos(y_position: float, delta: float):
	var distance = (y_position - position.y) * delta
	distance *= accuracy
	position.y = clamp(position.y + distance, minY, maxY)
