extends Node3D

@export var interact_name: String = ""
@export var is_interactable: bool = true
@export var door_open: bool = false

func activate():
	print("door should open.")
	if door_open == false:
		open_door()
		door_open = true
	elif door_open == true:
		close_door()
		door_open = false
	else:
		print("door_open value unknown.")
	pass

func open_door():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y + 90.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)

func close_door():
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees:y", rotation_degrees.y - 90.0, 0.5).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
