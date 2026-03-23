extends CharacterBody3D

@onready var neck = $Neck
@onready var camera = $Neck/CameraPivot/Camera

const SPEED = 8.0
const JUMP_VELOCITY = 3.0

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction: Vector3 = (neck.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
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
	
	move_and_slide()
