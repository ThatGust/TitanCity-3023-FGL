extends KinematicBody2D

const moveSpeed = 150
const maxSpeed = 200
const jumpHeight = -200
const up = Vector2(0,-1)
const gravity = 6

onready var sprite = $Sprite
onready var animationPlayer = $AnimationPlayer

var motion = Vector2()

func _physics_process(_delta):
	motion.y += gravity
	var friction = true

	if Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		animationPlayer.play("walk")
		motion.x = min(motion.x + moveSpeed, maxSpeed)

	elif Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		animationPlayer.play("walk")
		motion.x = max(motion.x - moveSpeed, -maxSpeed)
		
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			motion.y = jumpHeight
		if friction == true:
			motion.x = lerp(motion.x, 0.0, 0.5)
	else:
		if friction:
			motion.x = lerp(motion.x, 0.0, 0.01)

	motion = move_and_slide(motion,up)
	


