extends Area3D

#global variables and exports for tweaking
enum InteractionType {PICKUP_ITEM, INVENTORY_ADD, TRIGGER_EVENT}
@export var InteractType: InteractionType

@export var prompt_text: String = "Press _ to interact"
@export_node_path var prompt_label_path: NodePath
var prompt_label: Label3D

#prompt offset for 3dtext placement
@export var prompt_offset: Vector3= Vector3(0, -50, 0)

@export_node_path var target_object: NodePath
var target

var player_present: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Safely get the label node
	if get_node_or_null(prompt_label_path) is Label3D:
		prompt_label = get_node(prompt_label_path)
		prompt_label.visible = false
	else:
		push_warning("Prompt label not assigned or not a Label node.")

# Called when a body enters the area
func _on_body_entered(body: Node) -> void:
		if body.is_in_group("player"):
			player_present = true
			
			var target := get_node(target_object)
			
			if is_instance_valid(target):
				
				# gets relevant position data for 3d text
				var camera := get_current_camera()
				var forward := -camera.global_transform.basis.z
				var world_offset := camera.global_position + forward + prompt_offset
				
				#applies to 3d text
				if prompt_label:
					prompt_label.global_position = world_offset
					prompt_label.text = prompt_text
					prompt_label.visible = true
					

func get_current_camera() -> Camera3D:
	var viewport := get_viewport()
	if viewport:
		return viewport.get_camera_3d()
	return null

# Called when a body exits the area
func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_present = false
		
		#hides text
		if prompt_label:
			prompt_label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Handles the different actions given
	# by Interaction Type
	if player_present and Input.is_action_just_pressed("interact") and prompt_label.visible == true:
		
		var target := get_node(target_object)
		
		match InteractType:
			#I figure these branches can access a connected object's code for modularity
			#rather than hard coding design in, creeate a generic interaction script that allows
			#each item to be changed at that level, could be set up where most changes are
			#done in @export variables for convenience
			InteractionType.PICKUP_ITEM:
				#branch for pickup Item code
				print("Item (theoretically) picked up!")
				
				if target.has_method("pickup"):
					target.pickup()
					target.queue_free()
					prompt_label.visible = false;
				else:
					push_warning("Target does not have 'pickup' method.")
				
			InteractionType.INVENTORY_ADD:
				#branch for add to inventory code
				pass
			InteractionType.TRIGGER_EVENT:
				#branch for trigger event code
				pass
			_:
				#catch all
				print("Unknown Interaction Type")
