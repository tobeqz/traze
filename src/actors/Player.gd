extends Actor

export var top_speed: = 500
export var acceleration: = 8000
export var jump_power: = 500
export var airtime_grace_period: = 100
export var jump_grace_period: = 100
export var friction_factor: = 5000

var last_tick_in_air: = -10000
var last_jump_press: = -10000
func calculate_control_direction() -> float:
	var left_strength = Input.get_action_strength("move_left")
	var right_strength = Input.get_action_strength("move_right")
	
	return right_strength - left_strength
	
func _physics_process(delta):
	var current_tick: int = OS.get_ticks_msec()
	var time_since_air: = current_tick - last_tick_in_air

	# Calculate forced based on movement strength
	var control_force = calculate_control_direction() * acceleration

	# Is player considered on ground after grace period?
	var is_past_air_grace = time_since_air > airtime_grace_period && is_on_floor()

	# Keep timestamp of last jump for the grace period
	if Input.is_action_just_pressed("jump"):
		last_jump_press = current_tick

	# Handle jump
	var wants_to_jump = current_tick - last_jump_press < jump_grace_period
	if wants_to_jump && is_on_floor():
		velocity.y += -jump_power

	# If control direction is 0, add friction
	if control_force == 0:
		# Friction
		var speed_to_subtract = friction_factor * delta

		if velocity.x > 0:
			velocity.x -= speed_to_subtract
			velocity.x = clamp(velocity.x, 0, INF)
		else:
			velocity.x += speed_to_subtract
			velocity.x = clamp(velocity.x, -INF, 0)

	# Don't add extra velocity in mid air, but keep current velocity as long as user holds a or d
	if abs(velocity.x) < top_speed:
		velocity.x += control_force * delta
		velocity.x = clamp(velocity.x, -top_speed, top_speed)
	else:
		var move_dir = 0 if velocity.x == 0 else (1 if velocity.x > 0 else -1) 
		var control_dir = calculate_control_direction()

		if move_dir != control_dir:
			velocity.x += control_force * delta


	# Cap speed if player is on ground
	if is_past_air_grace:
		velocity.x = clamp(velocity.x, -top_speed, top_speed)

	print(velocity.x)

	velocity = move_and_slide(velocity, Vector2.UP)
	
