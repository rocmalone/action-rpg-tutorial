extends KinematicBody2D # Always extend the node we're attaching the script to.

# Movement variables
const ACCELERATION = 500
const MAX_SPEED = 80
const FRICTION = 600

var velocity = Vector2.ZERO

# Animation variables
#
# onready var will not create this variable until the Player node is ready.
# This is equivalent to setting var animationPlayer = null then setting the
# value of animationPlayer in the "func _ready():"
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# Get access to the animation state in order to set the proper animation (e.g. Idle or Run)
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Set blend position to the input vector to tie animation to movement direction
		animationTree.set("parameters/Run/blend_position", input_vector)
		# Important to set Idle as well as Run so that idle transition after running faces correct
		animationTree.set("parameters/Idle/blend_position", input_vector)
		
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	# move_and_slide returns the "leftover velocity" after the collision
	velocity = move_and_slide(velocity)

