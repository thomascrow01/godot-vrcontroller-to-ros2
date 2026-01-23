class_name IPVBox extends VBoxContainer

# file crated: 12-01-2026 - on a vline train rn

## used for getting and setting the ip/address for the websocket



var label: Label
var address_line_edit: LineEdit
var port_line_edit: LineEdit

var current_address: String # TODO inform user the websocket connection was successful
var current_port: int

var config: ConfigFile
const CONFIG_SECTION: String = "user"
const CONFIG_PATH: String = "user://config.cfg"

func _ready() -> void:
	label = get_node("Label")
	address_line_edit = get_node("HBoxContainer/AddressLineEdit")
	port_line_edit = get_node("HBoxContainer/PortLineEdit")
	
	config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK and config.get_sections().has(CONFIG_SECTION):
		address_line_edit.text = config.get_value(CONFIG_SECTION, "address")
		port_line_edit.text = str(config.get_value(CONFIG_SECTION, "port"))
	else:
		config.set_value(CONFIG_SECTION, "address", address_line_edit.text)
		config.set_value(CONFIG_SECTION, "port", int(port_line_edit.text))
		config.save(CONFIG_PATH)
	
	current_address = address_line_edit.text
	current_port = int(port_line_edit.text)

func _on_address_line_edit_text_submitted(new_text: String) -> void:
	current_address = new_text
	SignalBus.ip_or_port_changed.emit()
	config.set_value(CONFIG_SECTION, "address", current_address)
	print(config.save(CONFIG_PATH))


func _on_port_line_edit_text_submitted(new_text: String) -> void:
	current_port = int(new_text)
	SignalBus.ip_or_port_changed.emit()
	config.set_value(CONFIG_SECTION, "port", current_port)
	config.save(CONFIG_PATH)
