class_name IPVBox extends VBoxContainer

# file crated: 12-01-2026 - on a vline train rn

## used for getting and setting the ip/address for the websocket

var current_address: String = "localhost" # TODO inform user the websocket connection was successful
var current_port: int = 9090

@onready var label: Label = get_node("Label")
@onready var address_line_edit: LineEdit = get_node("HBoxContainer/AddressLineEdit")
@onready var port_line_edit: LineEdit = get_node("HBoxContainer/PortLineEdit")




func _on_address_line_edit_text_submitted(new_text: String) -> void:
	current_address = new_text


func _on_port_line_edit_text_submitted(new_text: String) -> void:
	current_port = int(new_text)
