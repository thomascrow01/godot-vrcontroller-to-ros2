class_name IPVBox extends VBoxContainer

# file crated: 12-01-2026 - on a vline train rn

## used for getting and setting the ip/address for the websocket



var label: Label
var address_line_edit: LineEdit
var port_line_edit: LineEdit

var current_address: String # TODO inform user the websocket connection was successful
var current_port: int

func _ready() -> void:
	label = get_node("Label")
	address_line_edit = get_node("HBoxContainer/AddressLineEdit")
	port_line_edit = get_node("HBoxContainer/PortLineEdit")
	
	current_address = address_line_edit.text
	current_port = int(port_line_edit.text)

func _on_address_line_edit_text_submitted(new_text: String) -> void:
	current_address = new_text
	SignalBus.ip_or_port_changed.emit()


func _on_port_line_edit_text_submitted(new_text: String) -> void:
	current_port = int(new_text)
	SignalBus.ip_or_port_changed.emit()
