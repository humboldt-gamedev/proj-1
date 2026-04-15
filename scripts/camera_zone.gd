extends Area3D

@export var target_camera: Camera3D

func _on_body_entered(body):
	if body.is_in_group("player"):
		target_camera.current = true
		body.set_camera_mode_corridor()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.set_camera_mode_player()
