extends Button

func _ready() -> void:
	text = tr("MENU_TOGGLE_ALL").replace("$state", str(true))

func _toggled(toggled_on: bool) -> void:
	SignalBus.toggle_all_trackers.emit(toggled_on)
	text = tr("MENU_TOGGLE_ALL").replace("$state", str(!toggled_on))
	
