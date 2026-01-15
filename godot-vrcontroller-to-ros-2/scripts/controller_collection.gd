extends XRController3D

@export var disabled: bool = false

@export var position_text: MeshInstance3D
@export var rotation_text: MeshInstance3D
@onready var websocket_manager: WebsocketManger = get_node("../Node")

func _process(_delta: float) -> void: # I'll look into the OpenXr actions later
	if disabled:
		return
		
	if is_button_pressed("grip"): # still need to check the correct controller
		
		#print(global_position)
		if position_text and position_text.mesh is TextMesh:
			position_text.mesh.text = "Position " + str(global_position)
			
		#print(global_basis.get_rotation_quaternion())
		if rotation_text and rotation_text.mesh is TextMesh:
			rotation_text.mesh.text = "Rotation " + str(global_basis.get_rotation_quaternion())
			
		#print(global_basis.)
			
		websocket_manager.send_data(str(global_position) + str(global_basis.get_rotation_quaternion()))
