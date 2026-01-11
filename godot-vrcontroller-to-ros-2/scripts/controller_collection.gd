extends XRController3D

@export var position_text: MeshInstance3D
@export var rotation_text: MeshInstance3D

func _process(_delta: float) -> void: # I'll look into the OpenXr actions later
	if is_button_pressed("trigger"):
		
		print(global_position)
		if position_text and position_text.mesh is TextMesh:
			position_text.mesh.text = "Position " + str(global_position)
			
		print(global_basis.get_rotation_quaternion())
		if rotation_text and rotation_text.mesh is TextMesh:
			rotation_text.mesh.text = "Rotation " + str(global_basis.get_rotation_quaternion())
