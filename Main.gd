extends Spatial

#1 meter = 0.01 units

var cubeWithBorders = preload("res://resources/cubeWithBorders.res")
var cubeWhite = preload("res://resources/cubeWhite.res")
var cubeTransparent = preload("res://resources/cubeTransparent.res")
var ground = preload("res://resources/ground.res")
var palm = preload("res://resources/palm.res")
var tree = preload("res://resources/tree.res")

var cubeCount = 0
#Details
var palmCount = 0
var treeCount = 0

#Buildings
var blockyBuildingCount = 0
var houseCount = 0
var piramidalBuildingCount = 0
var residentialBuildingsCount = 0

##Flags
#When enabled, the structure of the buildings is drawn
var drawStructure = true

#When enabled, palms, antennas and some other details are added
var drawDetails = true


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
	for i in range(3):
		for j in range(3):
			var toggle = randi() % 3
			if toggle == 0:
				addPiramidalBuilding(9 - j*4, 0, 9 - i*4, 1, 1)
			elif toggle == 1:
				addBlockyBuilding(9 - j*4, 0, 9 - i*4, 1, 1)
			elif toggle == 2:
				addResidentialBuildings(9 - j*4, 0, 9 - i*4, 1, 1, 0.80, 1.40)

#	addHouse(0, 0, 0, 1, 0.5)
#	addBlockyBuilding(0, 0, 0, 1, 1)
#	addPiramidalBuilding(0, 0, 4, 1, 1)
#	addPiramidalBuilding(0, 0, 0, 1, 1)
#	get_tree().call_group(0,"blocky0","set_rotation", Vector3(0, PI/2, 0))
#	addResidentialBuildings(0, 0, 8, 1, 1, 0.80, 1.40)
#	get_node("blocky0").set_rotation(Vector3(0, PI/3, 0))

	

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

#Adds a cube centered in x, y z with x dimension dx, y dimension dy and z dimension dz. Is structure is set, it draws the structure of the cube.
func addCube(x, y, z, dx, dy, dz, id, structure):

	print("Creating cube")
	
	if not structure:
		#Instanciate the .res
		var b = cubeWithBorders.instance()
		
		#Set a name so we can work with it later
		var currentName = "c" + str(cubeCount)
		b.set_name(currentName)
		
		#Move, and make sure it is above the ground
		b.set_translation(Vector3(x, y + dy, z))
		
		#Resize
		b.set_scale(Vector3(dx, dy, dz))
		
		#Add to node
		get_node(id).add_child(b)
		
		#Keep the count
		cubeCount += 1
		
	else:
			
		#Add a big transparent cube and then the structure
		#Windows
		var trans = cubeTransparent.instance()
		
		trans.set_translation(Vector3(x, y + dy, z))
		trans.set_scale(Vector3(dx, dy, dz))
		
		get_node(id).add_child(trans)
		cubeCount += 1
		
		#The framing
		var heightLeft = dy * 2
		var accumHeight = 0
		
		while(heightLeft > 0.03):
		
			##Instanciate the .res		
			#Floor framing
			var white = cubeWhite.instance()
			white.set_scale(Vector3(dx, 0.003, dz))
			white.set_translation(Vector3(x, y + 0.03/2 + accumHeight, z))
			
			#Add to node
			get_node(id).add_child(white)

			heightLeft -= 0.03
			accumHeight += 0.03
			
			#Keep the count
			cubeCount += 1
		
		#The a little top
		var white = cubeWhite.instance()
		white.set_scale(Vector3(dx, 0.003, dz))
		white.set_translation(Vector3(x, y + dy*2.0, z))
		
		get_node(id).add_child(white)
		cubeCount += 1
	
	print("Cube count: ", cubeCount)


#Adds a blocky building in x, y, z on an area of size*size
func addBlockyBuilding(x, y, z, dx, dz):

	var buildingName = "blocky" + str(blockyBuildingCount)
	
	#Create a node building that will contain all blocks
	var node = Spatial.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz, buildingName, false)
	
	##First block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.6 * dx)
	var dzBase = rand_range(0.4 * dz, 0.6 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	#Height
	var maxHeight = 0
	
	if randi() % 2 == 0:
		maxHeight = min(dxBase, dzBase) * 5
		
	else:
		maxHeight = max(dxBase, dzBase) * 5

	#This will set if the building has 4, 3 or one tower
	var shape = randi() % 10
	var xLocal = x + xOffset
	var zLocal = z + zOffset
	
	if shape == 0 or shape == 1: #20% of 4 towers
		
		addCube(xLocal + dxBase/2, y, zLocal + dzBase/2, dxBase/2, maxHeight, dzBase/2, buildingName, drawStructure)
		var h = rand_range(0.7 * maxHeight, 0.9 * maxHeight)
		addCube(xLocal + dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, buildingName, drawStructure)
		h = rand_range(0.7 * h, 0.9 * h)
		addCube(xLocal - dxBase/2, y, zLocal + dzBase/2, dxBase/2, h, dzBase/2, buildingName, drawStructure)
		h = rand_range(0.7 * h, 0.9 * h)
		addCube(xLocal - dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, buildingName, drawStructure)
		
	elif shape == 2: #10% of 3 towers
	
		addCube(xLocal + dxBase/2, y, zLocal + dzBase/2, dxBase/2, maxHeight, dzBase/2, buildingName, drawStructure)
		var h = rand_range(0.7 * maxHeight, 0.9 * maxHeight)
		addCube(xLocal + dxBase/2, y, zLocal - dzBase/2, dxBase/2, h, dzBase/2, buildingName, drawStructure)
		h = rand_range(0.7 * h, 0.9 * h)
		addCube(xLocal - dxBase/2, y, zLocal + dzBase/2, dxBase/2, h, dzBase/2, buildingName, drawStructure)
		h = rand_range(0.7 * h, 0.9 * h)
		
	else: #70% of regular building
	
		addCube(x + xOffset, y, z + zOffset, dxBase, maxHeight, dzBase, buildingName, drawStructure)
	
	if drawDetails:
		
		#Palms or trees
		var type = randi() % 2
		var both = randi() % 10
	
		if type == 0 or both == 0:
			##Add palms
			var palmNumber = randi() % 7
			
			for i in range(palmNumber):
			
				#Corner of the building + offset
				var xLocal = x + xOffset - dxBase - 0.05
				var zLocal = z + zOffset - dzBase - 0.05
						
				xLocal -= rand_range(0.01, xOffset*2)
				zLocal -= rand_range(0.01, zOffset*2)
				
				#Add it to the scene
				var p = palm.instance()
				var palmName = "p" + str(palmCount)
				palmCount += 1
				p.set_name(palmName)
	
				#Move, and make sure it is above the ground
				p.set_translation(Vector3(xLocal, 0.01, zLocal))
				
				#Resize
				var scale = p.get_scale()
				var modifier = rand_range(1, 3)
				p.set_scale(scale / modifier)
				
				#Rotate
				p.set_rotation(Vector3(PI/2, 0, rand_range(0, PI)))
				
				#Add it
				get_node(buildingName).add_child(p)
		
		elif type == 1 or both == 0:
		
			##Add trees
			var treeNumber = randi() % 3
			
			#Hide leaves?
			var leaves = randi() % 5
			
			for i in range(treeNumber):
			
				#Corner of the building + offset
				var xLocal = x + xOffset - dxBase - 0.05
				var zLocal = z + zOffset - dzBase - 0.05
						
				xLocal -= rand_range(0.01, xOffset*2)
				zLocal -= rand_range(0.01, zOffset*2)
				
				#Add it to the scene
				var t = tree.instance()
				var treeName = "t" + str(treeCount)
				treeCount += 1
				t.set_name(treeName)
				
				#Remove leaves 20% of the times
				if leaves == 0:
						t.get_child(1).set("geometry/visible", false)
	
				#Move, and make sure it is above the ground
				t.set_translation(Vector3(xLocal, 0.01, zLocal))
				
				#Resize
				var scale = t.get_scale()
				var modifier = rand_range(2, 4)
				t.set_scale(scale * modifier)
				
				#Rotate
				t.set_rotation(Vector3(0, rand_range(0, PI), 0))
				
				#Add it
				get_node(buildingName).add_child(t)
	
	blockyBuildingCount += 1

#Adds a piramidal building in x, y, z on an area of size*size
func addPiramidalBuilding(x, y, z, dx, dz):

	var buildingName = "piramidal" + str(houseCount)

	#Create a node building that will contain all blocks
	var node = Spatial.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz, buildingName, false)
	
	##Bottom block
	#Base
	var dxBase = rand_range(0.4 * dx, 0.6 * dx)
	var dzBase = rand_range(0.4 * dz, 0.6 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	#Height
	var maxHeight = 0
	
	if randi() % 2 == 0:
		maxHeight = min(dxBase, dzBase) * 5
		
	else:
		maxHeight = max(dxBase, dzBase) * 5
		
	#How many blocks
	var blocks = int(rand_range(3, 6))
	
	#Set the heights
	var heights = []
	
	for i in range(blocks):
		maxHeight /= 2
		heights.push_back(maxHeight)
	
	#Build the blocks
	var yPos = 0
	for i in range(blocks):
		addCube(x + xOffset, yPos, z + zOffset, dxBase, heights[i], dzBase, buildingName, drawStructure)
		yPos += 2* heights[i]
		dxBase *= rand_range(0.6, 0.8)
		dzBase *= rand_range(0.6, 0.8)
		
	##Add benches
	#if drawDetails:
		

#Adds residential buildings in x, y, z on an area of size * size with height between minHeight and maxHeight
func addResidentialBuildings(x, y, z, dx, dz, minHeight, maxHeight):

	var buildingName = "bunch" + str(residentialBuildingsCount)

	#Create a node building that will contain all blocks
	var node = Spatial.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz, buildingName, false)
	
	##Add row of buildings in Z axis
	#Widths
	var widths = []
	var widthLeft = dz
	
	while(widthLeft > 0.30):
		var w = rand_range(0.20, 0.28)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)
	
	#Create the blocks
	var acumWidth = 0
	for width in widths:
		addCube(x + dx - 0.2 * dx, y, z + dz - width - acumWidth, 0.2 * dx, rand_range(minHeight, maxHeight), width, buildingName, drawStructure)
		acumWidth += width * 2
	
	##Add row of buildings in the other side of the Z axis
	#Widths
	var widths = []
	var widthLeft = dz
	
	while(widthLeft > 0.30):
		var w = rand_range(0.20, 0.28)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
		addCube(x - dx + 0.2 * dx, y, z + dz - width - acumWidth, 0.2 * dx, rand_range(minHeight, maxHeight), width, buildingName, drawStructure)
		acumWidth += width * 2
		
	##Add row of buildings in the X axis
	#Widths
	var widths = []
	var widthLeft = dx - dx * 0.4
	
	while(widthLeft > 0.30):
		var w = rand_range(0.18, 0.23)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
		addCube(x + dx - width - 0.4 * dx - acumWidth, y, z + dz - 0.2 * dz, width, rand_range(minHeight, maxHeight), 0.2 * dz, buildingName, drawStructure)
		acumWidth += width * 2
		
	##Add the other row of buildings in the X axis
	#Widths
	var widths = []
	var widthLeft = dx - dx * 0.4
	
	while(widthLeft > 0.30):
		var w = rand_range(0.18, 0.23)
		widths.push_back(w)
		widthLeft -= w
	
	#Add the rest
	widths.push_back(widthLeft)

	#Create the blocks
	var acumWidth = 0
	for width in widths:
		addCube(x + dx - width - 0.4 * dx - acumWidth, y, z - dz + 0.2 * dz, width, rand_range(minHeight, maxHeight), 0.2 * dz, buildingName, drawStructure)
		acumWidth += width * 2
		
	residentialBuildingsCount += 1
	
#Adds a house in x, y, z on an area of size*size
func addHouse(x, y, z, dx, dz):

	var buildingName = "house" + str(houseCount)

	#Create a node building that will contain all blocks
	var node = Spatial.new()
	node.set_name(buildingName)
	add_child(node)
	
	#Floor
	addCube(x, y, z, dx, 0.005, dz, buildingName, false)
	
	##First block
	#Base
	var dxBase = 0.10#rand_range(0.4 * dx, 0.7 * dx)
	var dzBase = 0.10#rand_range(0.4 * dz, 0.7 * dz)
	
	#Offset from the middle
	var xOffset = rand_range(0, 0.4 * dx)
	var zOffset = rand_range(0, 0.4 * dz)
	
	addCube(x + xOffset, y, z + zOffset, dxBase, 0.06, dzBase, buildingName, drawStructure)
	
	houseCount += 1