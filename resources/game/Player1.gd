extends KinematicBody2D

const ACCELERATION = 40
const MAX_SPEED = 69
const FRICTION = 25

enum {
	MOVE,
	MINE
}

var state = MOVE
var velocity = Vector2.ZERO
var block_type

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _ready():
	animationTree.active = true

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		MINE:
			mining_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		animationTree.set("parameters/Mining/blend_position", input_vector)
		animationState.travel("Run")
		velocity += input_vector * ACCELERATION * delta
		velocity = velocity.clamped(MAX_SPEED * delta)
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	move_and_collide(velocity)
	
	if Input.is_action_pressed("click"):
		state = MINE
		if $RayCast2D.is_colliding():
			var point = $RayCast2D.get_collider().world_to_map($RayCast2D.get_collision_point())
		if .get_collider().get_cellv($RayCast2D.point) == 0:
			$RayCast2D.get_collider().set_cellv($RayCast2D.point,1)
		elif .get_collider().get_cellv($RayCast2D.point) == 1:
			$RayCast2D.get_collider().set_cellv($RayCast2D.point,-1)
		


	
	if !Input.is_action_pressed("click"):
		state = MOVE

func mining_state(delta):
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	velocity = move_and_slide(velocity)
	animationState.travel("Mining")

func mining_animation_finished():
	state = MOVE
	if Input.is_action_pressed("click"):
		state = MINE
