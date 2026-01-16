extends XRController3D

@export var disabled: bool = false

@export var acceleration_text: MeshInstance3D
@export var velocity_text: MeshInstance3D
@export var position_text: MeshInstance3D
@export var rotation_text: MeshInstance3D
@onready var websocket_manager: WebsocketManger = get_node("../WebsocketManager")

var last_timestamps: Array[float] # in unix time
var velocities: Array[Vector3]

func get_acceleration(v: Array[Vector3], times: Array[float]) -> Vector3:
	
	# getting acceleration using linear regression (x = time, y = velocity)
	
	var n = v.size()
	if n != times.size() or n < 2:
		return Vector3.ZERO

	var velocity_sum: Vector3 = Vector3.ZERO
	var time_sum: float = 0.0
	var time_squared_sum: float = 0.0
	var tv_sum: Vector3 = Vector3.ZERO # sum time * velocity

	for i in range(n):
		velocity_sum += v[i]
		time_sum += times[i]
		time_squared_sum += times[i] * times[i]
		tv_sum += v[i] * times[i] 

	# bottom part of the linear regression equation
	var denominator: float = n * time_squared_sum - time_sum * time_sum

	if denominator == 0.0: # avoid dividing by 0
		return Vector3.ZERO

	var acceleration: Vector3 = (n * tv_sum - velocity_sum * time_sum) / denominator
	return acceleration
	


func _process(_delta: float) -> void: # I'll look into the OpenXr actions later
	if disabled:
		return
		
	if is_button_pressed("grip"): # still need to check the correct controller
		
		var acceleration: Vector3
		var linear_velocity: Vector3 = get_pose().linear_velocity
		
		velocities.append(linear_velocity)
		last_timestamps.append(Time.get_unix_time_from_system())
		
		if velocities.size() >= 4:
			acceleration = get_acceleration(velocities, last_timestamps)
			velocities.clear()
			last_timestamps.clear()
		
		#
		#if velocities.size() == 0:
			#last_timestamp = Time.get_unix_time_from_system()
			#
		#velocities.append(linear_velocity)
			#
		#if velocities.size() >= 4:
			#
			#var average_velocity = Vector3.ZERO
			#for velocity in velocities:
				#average_velocity += velocity
			#average_velocity = average_velocity / velocities.size()
			#velocities.clear()
			#
			#acceleration = average_velocity / (Time.get_unix_time_from_system() - last_timestamp)
		
		if acceleration_text and acceleration_text.mesh is TextMesh and acceleration:
			acceleration_text.mesh.text = '"Acceleration" ' + str(acceleration)
		
		if velocity_text and velocity_text.mesh is TextMesh:
			velocity_text.mesh.text = "Velocity " + str(linear_velocity)
		
		#print(global_position)
		if position_text and position_text.mesh is TextMesh:
			position_text.mesh.text = "Position " + str(global_position)
			
		#print(global_basis.get_rotation_quaternion())
		if rotation_text and rotation_text.mesh is TextMesh:
			rotation_text.mesh.text = "Rotation " + str(global_basis.get_rotation_quaternion())

		
		if acceleration:
			websocket_manager.send_data(JSON.stringify({"data": {"time": Time.get_unix_time_from_system(),
																"position": global_position,
																"rotation": global_basis.get_rotation_quaternion(),
																"velocity": linear_velocity,
																"acceleration": acceleration}}))
		


func _on_button_pressed(button_name: String) -> void:
	var xr_server: XRInterface = XRServer.get_interface(0)
	if button_name == "ax_button" and xr_server.is_passthrough_supported():
		if !xr_server.is_passthrough_enabled():
			xr_server.start_passthrough()
		else:
			xr_server.stop_passthrough()
