class_name WebsocketManger extends Node

var socket = WebSocketPeer.new()

func _ready():
	_new_address()
	SignalBus.ip_or_port_changed.connect(_new_address)

func _new_address() -> void:
	set_process(false)
	var ip_vbox: IPVBox = get_node("../OpenXRCompositionLayerQuad/SubViewport/Control/IPVBox")
	set_new_address(ip_vbox.current_address, ip_vbox.current_port)

func set_new_address(address: String, port: int) -> void:
	socket.close()
	
	var websocket_url: String = "ws://" + address + ":" + str(port)
	print(websocket_url)
	
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		set_process(false)
	else:
		# Wait for the socket to connect.
		while socket.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
			print(str(socket.get_ready_state()))
			await get_tree().create_timer(2).timeout
			
		

		# Send data.
		print("sending test packet")
		socket.send_text(JSON.stringify({"op": "advertise",
						"topic": "/godotdata",
						"type": "std_msgs/msg/String"}))
		#print(socket.send_text('{"op": "advertise", "topic": "godotdata", "type": "std_msgs/msg/String"}')) #replace with actual json stuff later
		set_process(true)
		#send_data("TEST STRING")
		
func send_data(msg: String) -> void:
	if socket.get_ready_state() == WebSocketPeer.STATE_OPEN:
	
		#socket.send_text("{'op': 'advertise', 'topic': 'godotdata', 'msg': '" + msg + "'}")
		print("TEST SEND DATA")
		print(JSON.stringify({"op": "publish",
						"topic": "/godotdata",
						"msg": {"data": msg}}))
		print("send data: " + str(socket.send_text(JSON.stringify({"op": "publish",
						"topic": "/godotdata",
						"msg": {"data": msg}}))))
	
func _process(_delta):
	# Call this in _process or _physics_process. Data transfer and state updates
	# will only happen when calling this function.
	socket.poll()
	
	# get_ready_state() tells you what state the socket is in.
	var state = socket.get_ready_state()

	# WebSocketPeer.STATE_OPEN means the socket is connected and ready
	# to send and receive data.

	if state == WebSocketPeer.STATE_OPEN:
		while socket.get_available_packet_count():
			socket.get_available_packet_count()
			print("Got data from server: ", socket.get_packet().get_string_from_utf8())

	# WebSocketPeer.STATE_CLOSING means the socket is closing.
	# It is important to keep polling for a clean close.
	elif state == WebSocketPeer.STATE_CLOSING:
		pass

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		set_process(false) # Stop processing.
