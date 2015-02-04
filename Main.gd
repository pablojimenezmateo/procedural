
extends Spatial


# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	set_process_input(true)
		
func _process(delta):
#
#	var active_camera = get_node("ghost/cam")
#	var transform = active_camera.get_camera_transform()
#	var pos = transform.origin
#	
#	var camSpeed = 5
#			
#	if (Input.is_action_pressed("ui_left")):
#
#		#We will move one unit ahead
#		var newPos = Vector3(-delta*camSpeed, 0, 0)
#
#		#Create the transformation		
#		var newTransform = transform.translated(newPos)
#		
#		#Move it
#		active_camera.set_transform(newTransform)
#		
#	elif (Input.is_action_pressed("ui_right")):
#	
#		#We will move one unit ahead
#		var newPos = Vector3(delta*camSpeed, 0, 0)
#
#		#Create the transformation		
#		var newTransform = transform.translated(newPos)
#		
#		#Move it
#		active_camera.set_transform(newTransform)
#		
#	elif (Input.is_action_pressed("ui_up")):
#	
#		#We will move one unit ahead
#		var newPos = Vector3(0, 0, -delta*camSpeed)
#
#		#Create the transformation		
#		var newTransform = transform.translated(newPos)
#		
#		#Move it
#		active_camera.set_transform(newTransform)
#		
#	elif (Input.is_action_pressed("ui_down")):
#	
#		#We will move one unit ahead
#		var newPos = Vector3(0, 0, delta*camSpeed)
#
#		#Create the transformation		
#		var newTransform = transform.translated(newPos)
#		
#		#Move it
#		active_camera.set_transform(newTransform)
#		
#	elif (Input.is_action_pressed("ui_page_up")): # Rotation to the right
#
#		#We will move one unit ahead
#		var newPos = Vector3(0, delta*camSpeed, 0)
#
#		#Create the transformation
#		var newTransform = transform.rotated(newPos, 3.141592654/16)
#
#		#Move it
#		active_camera.set_transform(newTransform)

#	elif (Input.is_action_pressed("ui_page_up")): # Rotation to the bottom
#
#		#We will move one unit ahead
#		var newPos = Vector3(delta*camSpeed, 0, 0)
#
#		#Create the transformation
#		var newTransform = transform.rotated(newPos, 3.141592654/16)
#
#		#Move it
#		active_camera.set_transform(newTransform)
	var camSpeed = 5
	var camera = get_node("ghost_cam")

	
	if Input.is_action_pressed("ui_up"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_down"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_left"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[0] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_right"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[0] * delta* camSpeed)
		


var yaw = 0
var pitch = 0

func _input(event):
	var view_sensitivity = 0.3
	var camera = get_node("ghost_cam")
	
	if (event.type == InputEvent.MOUSE_MOTION):
	
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90)
		
		camera.set_rotation(Vector3(0, deg2rad(yaw), 0)) #Moves left and right
		camera.set_rotation(Vector3(deg2rad(pitch), 0, 0)) #Moves up and down
