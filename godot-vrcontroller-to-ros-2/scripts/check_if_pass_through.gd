extends Label

func _ready() -> void:
	if !XRServer.get_interface(0).is_passthrough_supported(): # if we can pass through, show that we can
		text = tr("MENU_PASSTHROUGH_UNSUPPORTED")
