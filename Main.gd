extends Spatial

var cube = preload("res://resources/cube.res")
var ground = preload("res://resources/ground.res")

#Where the cube names
var cubes = []
var cubeCount = 0

func _ready():

	#The initial seed
	rand_seed(42)

	set_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#Add ground
	var g = ground.instance()
	g.set_name("ground")
	add_child(g)
	
	#Trials
	blockyBuilding(0, 0, 0, 0.4, 1)

#This is used to translate the camera around
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

#Horizontal movement
var yaw = 0

#Vertical movement
var pitch = 0

#This function is used to rotate the camera
func _input(event):

	var view_sensitivity = 0.003
	var camera = get_node("ghost_cam")
	var cube = get_node("TestCube")
	
	if (event.type == InputEvent.MOUSE_MOTION):
	
		#Calculate the rotation angle
		yaw = yaw - event.relative_x * view_sensitivity 
		pitch = pitch - event.relative_y * view_sensitivity
	
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

#Adds a cube centered in x, y z with x dimension dx, y dimension dy and z dimension dz
func addCube(x, y, z, dx, dy, dz):

	print("Creating cube")
	print("Cube count: ", cubeCount)
	
	#Instanciate the .res
	var b = cube.instance()
	
	#Set a name so we can work with it later
	var currentName = "c" + str(cubeCount)
	b.set_name(currentName)
	
	#Add it to the scene
	add_child(b)
	
	#Move, and make sure it is above the ground
	get_node(currentName).set_translation(Vector3(x, y + dy, z))
	
	#Resize
	get_node(currentName).set_scale(Vector3(dx, dy, dz))
	
	#Keep the count
	cubeCount += 1

#Adds a blocky building in x, y, z on an area of size*size and height maxHeight
func blockyBuilding(x, y, z, size, maxHeight):
	
	#Floor
	addCube(x, y, z, size, 0.005, size)
		
	##First block
	#Base
	var dxBase = rand_range(0.4 * size, 0.6 * size)
	var dzBase = rand_range(0.4 * size, 0.6 * size)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * size)
	var zOffset = rand_range(0, 0.4 * size)
	
	addCube(x + xOffset, y, z + zOffset, dxBase, maxHeight, dzBase)
	
	##Rest of the blocks
	var h = maxHeight
	
	#Stop when we want to put a building of height lesss than the 20% of the original height
	while(h > 0.5 * maxHeight):
		
		#The height for the next "addition" must be lower than the previous one
		h = rand_range(0.5 * h, h)
		
		#Creates the new cube outside the big building, its size cannot be lower than the 30% of the original size
		#and it cannot leave the floor
		var dxLocal = rand_range(0.25 * size, min(xOffset, zOffset))
		var dzLocal = rand_range(0.25 * size, min(xOffset, zOffset))
		
		#This coordinates will put the new buildings in the corner of the big one
		var xLocal = x + xOffset - dxBase - dxLocal
		var zLocal = z + zOffset - dzBase - dzLocal
		
		#Now we calculate the final position of the new building, either move in the X side or the Z
		var toggleAxis = randi() % 2
		xLocal = xLocal + rand_range(dxLocal*2, dxBase*2) * toggleAxis
		zLocal = zLocal + rand_range(dzLocal*2, dzBase*2) * ((toggleAxis + 1) % 2)
		
		addCube(xLocal, y, zLocal, dxLocal, h, dzLocal)
		
	