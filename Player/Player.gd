extends KinematicBody2D # Always extend the node we're attaching the script to.

# Movement variables
const ACCELERATION = 500
const MAX_SPEED = 80
const ROLL_SPEED = 125
const FRICTION = 600

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.LEFT

# Animation variables
#
# onready var will not create this variable until the Player node is ready.
# This is equivalent to setting var animationPlayer = null then setting the
# value of animationPlayer in the "func _ready():"
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
# Get access to the animation state in order to set the proper animation (e.g. Idle or Run)
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	# Start animations playing
	animationTree.active = true


func _physics_process(delta):
	# Match statement ~ switch statement
	match state:
		MOVE:
			move_state(delta)
		
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)



func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	# MOVEMENT INPUT HANDLING
	# If non-zero input - perform code
	if input_vector != Vector2.ZERO:

		# Ensure roll is same direction as movement
		roll_vector = input_vector


		# Set blend position to the input vector to tie animation to movement direction
		animationTree.set("parameters/Run/blend_position", input_vector)
		# Important to set Idle as well as Run so that idle transition after running faces correct
		animationTree.set("parameters/Idle/blend_position", input_vector)
		# Same as above for attack
		animationTree.set("parameters/Attack/blend_position", input_vector)
		# Same as above for roll
		animationTree.set("parameters/Roll/blend_position", input_vector)
		
		# Transition to 'Run' blend space
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move()

	# Transition to ATTACK state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

	# Transition to ROLL state
	if Input.is_action_just_pressed("roll"):
		state = ROLL


func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()


func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func move():
	# move_and_slide returns the "leftover velocity" after the collision
	velocity = move_and_slide(velocity)


func roll_animation_finished():
	velocity = velocity * 0.8
	state = MOVE


func attack_animation_finished():
	state = MOVE



