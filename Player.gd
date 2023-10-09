extends KinematicBody2D

const ACCELERATION = 1960
const MAX_SPEED = 255
const FRICTION = 900
const gravity = 6
const jumpHeight = -400
const up = Vector2(0,-1)
var velocity = Vector2.ZERO
onready var animPlayer = $AnimationPlayer
onready var sprite = $Sprite

var motion = Vector2()

func _physics_process(delta):
	motion.y += gravity
	var friction = true
	
	var input_x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input_x < 0:
		sprite.flip_h = true
	elif input_x > 0:
		sprite.flip_h = false
	
	if input_x != 0:
		velocity = velocity.move_toward(Vector2(input_x, 0) * MAX_SPEED, ACCELERATION * delta)
		animPlayer.play("Run", -1, 2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animPlayer.play("Idle")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_on_floor():
		if Input.is_action_pressed("ui_accept"):
			motion.y = jumpHeight
		if friction == true:
			motion.x = lerp(motion.x, 0.0, 0.5)
	else:
		if friction:
			motion.x = lerp(motion.x, 0.0, 0.01)
			
	motion = move_and_slide(motion,up)


func _input(event):
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
