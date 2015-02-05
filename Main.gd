
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
		


var yaw = 0
var pitch = 0

func _input(event):
	var view_sensitivity = 0.003
	var camera = get_node("ghost_cam")
	var cube = get_node("TestCube")
	
	if (event.type == InputEvent.MOUSE_MOTION):
	
		yaw = fmod(yaw - event.relative_x * view_sensitivity, 360)
		pitch = max(min(pitch - event.relative_y * view_sensitivity, 90), -90)
		
		#camera.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0)) #Moves left and right
		#camera.set_rotation(Vector3(0, deg2rad(yaw), 0)) #Moves left and right
		#camera.set_rotation(Vector3(deg2rad(pitch), 0, 0)) #Moves up and down

		#cube.set_rotation(Vector3(deg2rad(pitch), deg2rad(yaw), 0)) #Moves left and right
		#cube.set_rotation(Vector3(0, deg2rad(yaw), 0)) #Moves left and right
		#cube.set_rotation(Vector3(deg2rad(pitch), 0, 0)) #Moves up and down

		#var origin = camera.get_global_transform().origin
		#var basis = camera.get_global_transform().basis
		
		var q = Quat()

#		var cross = cube.get_global_transform().origin.cross(Vector3(0.1,0.1,0))
#		
#		print(cube.get_global_transform().origin, " Basis: ", cube.get_global_transform().basis[0])
#		q.x = cross[0];
#		q.y = cross[1];
#		q.z = cross[2];
#		q.w = sqrt(cube.get_global_transform().origin.length_squared() * Vector3(0.1,0.1,0).length_squared()) + cube.get_global_transform().origin.dot(Vector3(0.1,0.1,0))
#		
#		q.w = 0.9239
#		q.x = 0
#		q.y = 0.3827
#		q.z = 0
#		q = q.normalized()
		
		print(q)
		
		var c1 = cos(yaw/2)
		var c2 = cos(pitch/2)
		var c3 = 1
		var s1 = sin(yaw/2)
		var s2 = sin(pitch/2)
		var s3 = 0
		q.w = c1 * c2 * c3 - s1 * s2 * s3
		q.x = s1 * s2 * c3 + c1 * c2 * s3
		q.y = s1 * c2 * c3 + c1 * s2 * s3
		q.z = c1 * s2 * c3 - s1 * c2 * s3
		q = q.normalized()
		
		print(q)

		#var transform = camera.get_global_transform().rotated(q)
		#var transform = camera.get_global_transform().rotated(Vector3(1, 0, 0), deg2rad(pitch))
		#var trans = camera.get_translation()
		cube.set_global_transform(Transform(q))

		#camera.set_translation(trans)