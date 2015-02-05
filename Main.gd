
extends Spatial


# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	set_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
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
	var cube = get_node("TestCube")

	
	if Input.is_action_pressed("ui_up"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[2] * delta* camSpeed)
		#cube.set_translation(cube.get_translation() - cube.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_down"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[2] * delta* camSpeed)
		#cube.set_translation(cube.get_translation() + cube.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_left"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[0] * delta* camSpeed)
		#cube.set_translation(cube.get_translation() - cube.get_global_transform().basis[0] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_right"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[0] * delta* camSpeed)
		#cube.set_translation(cube.get_translation() + cube.get_global_transform().basis[0] * delta* camSpeed)
		
	if Input.is_action_pressed("quit"):
		get_tree().quit()
		


var yaw = 0
var pitch = 0

func _input(event):
	var view_sensitivity = 0.003
	var camera = get_node("ghost_cam")
	var cube = get_node("TestCube")
	
	if (event.type == InputEvent.MOUSE_MOTION):
	
		yaw = yaw - event.relative_x * view_sensitivity #Horizontal
		pitch = pitch - event.relative_y * view_sensitivity #Vertical
				
		#The basic explanation with examples can be found here
		#http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/steps/index.htm
		#This helps a lot http://wiki.alioth.net/index.php/Quaternion
#		var c1 = cos(yaw/2)
#		var c2 = cos(pitch/2)
#		var c3 = 1
#		var s1 = sin(yaw/2)
#		var s2 = sin(pitch/2)
#		var s3 = 0
#		
#		q.w = c1 * c2 * c3 - s1 * s2 * s3
#		q.x = s1 * s2 * c3 + c1 * c2 * s3
#		q.y = s1 * c2 * c3 + c1 * s2 * s3
#		q.z = c1 * s2 * c3 - s1 * c2 * s3
#		q = q.normalized()
		
		#Yeah!, maths!
		var qy = Quat()
		var qx = Quat()
		var q = Quat()
		
		#Create the quaternion for the Y axis movement
		qy.w = cos(yaw/2)
		qy.x = sin(yaw/2) * 0
		qy.y = sin(yaw/2) * 1
		qy.z = sin(yaw/2) * 0
		qx = qx.normalized()
		
		#Create the quaternion for the X axis movement
		qx.w = cos(pitch/2)
		qx.x = sin(pitch/2) * 1
		qx.y = sin(pitch/2) * 0
		qx.z = sin(pitch/2) * 0
		qx = qx.normalized()
		
		#Get the final quaternion http://en.wikipedia.org/wiki/Slerp
		q = qy.slerp(qx, 0.5)
		q = q.normalized()
		
		print(yaw, " ### ", q)
		
		#The transformation moves the camera to the origin, so we need to store its previous position to move it back
		#var trans = camera.get_translation()
		
		#Rotate the camera
		camera.set_global_transform(Transform(q))
		
		#Move it back
		#camera.set_translation(trans)