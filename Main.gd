extends Spatial

func _ready():
	set_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
func _process(delta):

	var camSpeed = 5
	var camera = get_node("ghost_cam")
	var cube = get_node("TestCube")
	
	if Input.is_action_pressed("ui_up"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_down"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[2] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_left"):
		camera.set_translation(camera.get_translation() - camera.get_global_transform().basis[0] * delta* camSpeed)
		
	if Input.is_action_pressed("ui_right"):
		camera.set_translation(camera.get_translation() + camera.get_global_transform().basis[0] * delta* camSpeed)
		
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
	
		#Yeah!, maths!
		
		#The basic explanation with examples can be found here
		#http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/steps/index.htm
		var q  = Quat()
		var c1 = cos(yaw/2)
		var c2 = 1
		var c3 = cos(pitch/2)
		var s1 = sin(yaw/2)
		var s2 = 0
		var s3 = sin(pitch/2)
		
		q.w = c1 * c2 * c3 - s1 * s2 * s3
		q.x = s1 * s2 * c3 + c1 * c2 * s3
		q.y = s1 * c2 * c3 + c1 * s2 * s3
		q.z = c1 * s2 * c3 - s1 * c2 * s3
		q = q.normalized()
		
		#The transformation moves the camera to the origin, so we need to store its previous position to move it back
		var trans = camera.get_translation()
		
		#Rotate the camera
		camera.set_global_transform(Transform(q))
		
		#Move it back
		camera.set_translation(trans)