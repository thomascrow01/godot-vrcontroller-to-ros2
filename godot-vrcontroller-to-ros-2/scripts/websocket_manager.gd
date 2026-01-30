class_name WebsocketManger extends Node

var socket: WebSocketPeer = WebSocketPeer.new()
var ip_vbox: IPVBox

func _ready():
	ip_vbox = get_node("../OpenXRCompositionLayerQuad/SubViewport/Control/IPVBox")
	_new_address()
	SignalBus.ip_or_port_changed.connect(_new_address)

func _new_address() -> void:
	set_process(true)
	set_new_address(ip_vbox.current_address, ip_vbox.current_port)

func set_new_address(address: String, port: int) -> void:
	socket.close()
	
	var websocket_url: String = "ws://" + address + ":" + str(port)
	print(websocket_url)
	
	# Initiate connection to the given URL.
	var err = socket.connect_to_url(websocket_url)
	if err != OK:
		print("Unable to connect")
		ip_vbox.label.text = tr("MENU_FAILED_WEBSOCKET")
		set_process(false)
	else:
		# Wait for the socket to connect.
		while socket.get_ready_state() == WebSocketPeer.STATE_CONNECTING:
			print("Connecting")
			ip_vbox.label.text = tr("MENU_CONNECTING_WEBSOCKET")
			print(socket.get_requested_url())
			await get_tree().create_timer(2).timeout
			
		

		# Send data.
		socket.send_text(JSON.stringify({"op": "advertise",
						"topic": "/godotdata",
						"type": "std_msgs/msg/String"}))
		#print(socket.send_text('{"op": "advertise", "topic": "godotdata", "type": "std_msgs/msg/String"}')) #replace with actual json stuff later
		set_process(true)
		ip_vbox.label.text = tr("MENU_SUCCESS_WEBSOCKET") # yes I know I should probably confirm this
		
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
		ip_vbox.label.text = tr("MENU_CLOSING_WEBSOCKET")

	# WebSocketPeer.STATE_CLOSED means the connection has fully closed.
	# It is now safe to stop polling.
	elif state == WebSocketPeer.STATE_CLOSED:
		# The code will be -1 if the disconnection was not properly notified by the remote peer.
		var code = socket.get_close_code()
		print("WebSocket closed with code: %d. Clean: %s" % [code, code != -1])
		ip_vbox.label.text = tr("MENU_CLOSED_WEBSOCKET")
		set_process(false) # Stop processing.
