extends Node3D

@onready var camera_pos = $"../Player/CameraPos"
@onready var camera_pivot = $Pivot
@onready var camera = $Pivot/Camera

func _physics_process(_delta: float) -> void:
	position = camera_pos.global_position

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MouseButton.MOUSE_BUTTON_LEFT:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	var mouse_movement = Vector2.ZERO
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		mouse_movement = event.screen_relative
	
	rotation.y -= mouse_movement.x * 0.01
	camera_pivot.rotation.x -= mouse_movement.y * 0.01
	camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, -PI / 2, PI / 2)

func get_camera_basis() -> Basis:
	return camera.global_basis

func get_camera() -> Camera3D:
	return camera
