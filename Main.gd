extends Spatial

var cube = preload("res://resources/cube.res")
var ground = preload("res://resources/ground.res")
var palm = preload("res://resources/palm.res")

var cubeCount = 0
var palmCount = 0

func _ready():

	#The initial seed
	#rand_seed(42)
	randomize()

	set_process(true)
	set_process_input(true)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	#Add ground
	var g = ground.instance()
	g.set_name("ground")
	add_child(g)
	
	#Trials
#	for i in range(10):
#		blockyBuilding(0, 0, 9 - i*2, rand_range(0.4, 1), rand_range(0.4, 1), rand_range(0.5, 1))
	house(0, 0, 0, 1, 1)

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
func blockyBuilding(x, y, z, dx, dz, maxHeight):
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz)
		
	##First block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.6 * dx)
	var dzBase = rand_range(0.4 * dz, 0.6 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	addCube(x + xOffset, y, z + zOffset, dxBase, maxHeight, dzBase)
	
	##Rest of the blocks
	#Vector to store the new block positions so they don't overlap
	var nodes = []
	var h = maxHeight
	
	#Stop when we want to put a building of height less than the 20% of the original height
	while(h > 0.2 * maxHeight):
		
		#The height for the next "addition" must be lower than the previous one
		h = rand_range(0.5 * h, h)
		
		#Creates the new cube outside the big building, its size cannot be lower than the 25% of the original size
		#and it cannot leave the parcel
		var dxLocal = rand_range(0.25 * dx, min(xOffset, zOffset)) - 0.01
		var dzLocal = rand_range(0.25 * dz, min(xOffset, zOffset)) - 0.01
		
		#This coordinates will put the new buildings in the corner of the big one
		var xLocal = x + xOffset - dxBase - dxLocal
		var zLocal = z + zOffset - dzBase - dzLocal

		#Now we calculate the final position of the new building, either move in the X side or the Z
		var toggleAxis = randi() % 2
		xLocal = xLocal + rand_range(dxLocal*2, dxBase*2) * toggleAxis
		zLocal = zLocal + rand_range(dzLocal*2, dzBase*2) * ((toggleAxis + 1) % 2)

		#Does it intersect with a previous node? If it does don't build it.
		#Note that I will allow lower but wider buildings to spawn even thoguh another building is already there.
		#That leads to some kind of towers.
		var collision = false
		
		for node in nodes:
			if(node[4] == 1): #X axis
				if(((xLocal - dxLocal >= node[0] - node[2]) and (xLocal - dxLocal <= node[0] + node[2])) or ((xLocal + dxLocal >= node[0] - node[2]) and (xLocal + dxLocal <= node[0] + node[2]))):
						collision = true
			else:
				if(((zLocal - dzLocal >= node[1] - node[3]) and (zLocal - dzLocal <= node[1] + node[3])) or ((zLocal + dzLocal >= node[1] - node[3]) and (zLocal + dzLocal <= node[1] + node[3]))):
					collision = true

		if not collision:
			addCube(xLocal, y, zLocal, dxLocal, h, dzLocal)
			nodes.push_back([xLocal, zLocal, dxLocal, dzLocal, toggleAxis])
				
	##Add palms
	var palmNumber = randi() % 7
	
	for i in range(palmNumber):
	
		#Corner of the building + offset
		var xLocal = x + xOffset - dxBase - 0.05
		var zLocal = z + zOffset - dzBase - 0.05
		
		#Distance from the corner of the building to the corner of the base
		var dist = sqrt(pow(xLocal - x + dxBase, 2) + pow(zLocal - z + dzBase,2))
		
		xLocal -= rand_range(0, dist)
		zLocal -= rand_range(0, dist)
		
		#Add it to the scene
		var p = palm.instance()
		var name = "p" + str(palmCount)
		palmCount += 1
		p.set_name(name)
		add_child(p)
		
		#Move, and make sure it is above the ground
		get_node(name).set_translation(Vector3(xLocal, 0, zLocal))
		
		#Resize
		var scale = get_node(name).get_scale()
		var modifier = rand_range(0.1, 1)
		get_node(name).set_scale(scale * modifier)
		
		#Rotate
		get_node(name).set_rotation(Vector3(deg2rad(90), 0, deg2rad(rand_range(0, 180))))

#Adds a house in x, y, z on an area of size*size
func house(x, y, z, dx, dz):

	#Floor
	addCube(x, y, z, dx, 0.005, dz)
		
	##First block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.7 * dx)
	var dzBase = rand_range(0.4 * dz, 0.7 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	addCube(x + xOffset, y, z + zOffset, dxBase, min(dx, dz) / 3.5, dzBase)