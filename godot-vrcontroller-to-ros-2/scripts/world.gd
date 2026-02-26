extends StartXR

#var xr_interface: XRInterface

# https://docs.godotengine.org/en/stable/tutorials/xr/setting_up_xr.html

func _ready():
	super()
	
	#xr_interface = XRServer.find_interface("OpenXR")
	#if xr_interface and xr_interface.is_initialized():
		#print("OpenXR initialized successfully")
#
		## Turn off v-sync!
		#DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
#
		## Change our main viewport to output to the HMD
		#get_viewport().use_xr = true
	#else:
		#print("OpenXR not initialized, please check if your headset is connected")
	XRServer.tracker_added.connect(markers)
	print(XRServer.get_trackers(XRServer.TRACKER_ANY))
	
func markers(tracker_name: StringName, type: int) -> void:
	print("tracker found: " + tracker_name)
	if type != XRServer.TRACKER_ANCHOR:
		return
	
	var tracker: XRTracker = XRServer.get_tracker(tracker_name)
	if tracker is OpenXRMarkerTracker:
		print("found marker")
		match tracker.marker_type:
			OpenXRSpatialComponentMarkerList.MARKER_TYPE_ARUCO:
				print("Aruco tag id: " + str(tracker.marker_id))
			OpenXRSpatialComponentMarkerList.MARKER_TYPE_QRCODE:
				print("qr code: " + str(tracker.get_marker_data()))
			_:
				print("Not Aruco or QRCODE tag")
	
