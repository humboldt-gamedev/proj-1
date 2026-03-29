extends Node3D

@export var interact_name: String = ""
@export var is_interactable: bool = true

func addToInv():
	pass

func pickup():
	print("got to pickup function in target.")

func activate():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
