extends Label

func _ready() -> void:
	print(XRServer.get_interface(0).get_supported_environment_blend_modes())
	if !XRServer.get_interface(0).is_passthrough_supported(): # if we can pass through, show that we can
		text = tr("MENU_PASSTHROUGH_UNSUPPORTED")
