extends CharacterBody3D

@onready var current_camera: Camera3D = get_viewport().get_camera_3d()
@onready var player_camera: Node3D = $"../PlayerCamera"
var movement_basis: Basis

enum CameraMode {PLAYER, CORRIDOR}
var current_camera_mode = CameraMode.PLAYER

# Global paramaters for character movement
@export var SPEED = 3
@export var ROTATION_SPEED = 2.7
@export var JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	
	if Input.is_action_just_pressed("toggle_camera"):
		current_camera = player_camera.get_camera()
		current_camera.current = true
		current_camera_mode = CameraMode.PLAYER
		movement_basis = current_camera.global_transform.basis
	
	# sets camera bias to current 3d camera
	if current_camera != get_viewport().get_camera_3d():
		current_camera = get_viewport().get_camera_3d()
		movement_basis = current_camera.global_transform.basis
	
	match current_camera_mode:
		CameraMode.PLAYER:
			if not is_on_floor():
				velocity += get_gravity() * delta
			
			if Input.is_action_just_pressed("jump") and is_on_floor():
				velocity.y = JUMP_VELOCITY
			
			var direction: Vector3 = (player_camera.get_basis() * Vector3(input_dir.x, 0, input_dir.y)).normalized()
			if direction:
				velocity.x = direction.x * SPEED
				velocity.z = direction.z * SPEED
			else:
				var xz: Vector2
				xz.x = velocity.x
				xz.y = velocity.z
				xz = xz.move_toward(Vector2.ZERO, SPEED * 2 * delta)
				velocity.x = xz.x
				velocity.z = xz.y
			
			if direction:
				var target_angle = atan2(direction.x, direction.z)
				rotation.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)
		
		CameraMode.CORRIDOR:
			# when not moving, slow velocity towards zero vector
			if input_dir == Vector2.ZERO:
				velocity = velocity.move_toward(Vector3.ZERO, SPEED * delta * 2)
			else:
				if movement_basis == Basis():
					movement_basis = current_camera.global_transform.basis
				
				# calculate facing direction of camera and assign it to movement_basis
				var camera_forward = -movement_basis.z
				var camera_right = movement_basis.x
				camera_forward.y = 0
				camera_forward = camera_forward.normalized()
				
				# get move direction by adding input movement to the base camera
				var move_direction = (camera_forward * -input_dir.y + camera_right * input_dir.x)
				move_direction = move_direction.normalized()
				
				# get the forward facing direction of the player character
				var character_forward = Vector3(sin(rotation.y), 0, cos(rotation.y))
				
				# when moving, rotate the charater towards the desired
				# location (reduces "snapping" and makes movement smoother)
				if move_direction.length() > 0.1:
					var target_angle = atan2(move_direction.x, move_direction.z)
					rotation.y = lerp_angle(rotation.y, target_angle, delta * ROTATION_SPEED)
				
				# Apply velocity to character
				velocity.x = character_forward.x * SPEED
				velocity.z = character_forward.z * SPEED
	
	# When attempting to move, change animation to walking
	if velocity.length() > 0.1:
		$AnimationTree["parameters/playback"].travel("Walk Cycle")
	else:
		$AnimationTree["parameters/playback"].travel("Idle")
		
	
	move_and_slide()

func set_camera_mode_corridor():
	current_camera_mode = CameraMode.CORRIDOR
