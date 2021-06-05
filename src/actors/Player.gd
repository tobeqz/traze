extends Actor

export var speed: = 30000
export var jump_power: = 500
export var bhop_tolerance: = 200
export var bhop_add_mult: = 0.15

var last_jump_input: int = -200
var bhop_mult: float = 1.00

func _physics_process(delta: float):
	var strength_right: = Input.get_action_strength("move_right")
	var strength_left: = Input.get_action_strength("move_left")
	var strength_down: = Input.get_action_strength("move_down")

	var pressed_jump: = Input.is_action_just_pressed("jump")

	if pressed_jump:
		last_jump_input = OS.get_ticks_msec()

	var should_jump: =  OS.get_ticks_msec() -  last_jump_input < 200

	velocity.y += strength_down * speed * delta
	velocity.x = (strength_right - strength_left) * speed * delta * bhop_mult

	if should_jump && is_on_floor():
		print("Jumping")
		velocity.y -= jump_power
		bhop_mult += bhop_add_mult

	if !should_jump && is_on_floor():
		bhop_mult = 1.00

	velocity = move_and_slide(velocity)



