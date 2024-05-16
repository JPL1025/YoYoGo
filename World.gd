extends Node2D

# Preload the room scene
const RoomLoad = preload("res://Room.tscn")

# Preload tilesets
const t1 = preload("res://TileMap1.tscn")
const t2 = preload("res://TileMap2.tscn")
const t3 = preload("res://TileMap3.tscn")
const t4 = preload("res://TileMap4.tscn")
const t5 = preload("res://TileMap5.tscn")
const t6 = preload("res://TileMap6.tscn")
const t7 = preload("res://TileMap7.tscn")
const t8 = preload("res://TileMap8.tscn")
const t9 = preload("res://TileMap9.tscn")
const t10 = preload("res://TileMap10.tscn")
const t11 = preload("res://TileMap11.tscn")
const t12 = preload("res://TileMap12.tscn")
const t13 = preload("res://TileMap13.tscn")

# Preload the number sprites
const Zero = preload("res://Sprites/0.png")
const One = preload("res://Sprites/1.png")
const Two = preload("res://Sprites/2.png")
const Three = preload("res://Sprites/3.png")
const Four = preload("res://Sprites/4.png")
const Five = preload("res://Sprites/5.png")
const Six = preload("res://Sprites/6.png")
const Seven = preload("res://Sprites/7.png")
const Eight = preload("res://Sprites/8.png")
const Nine = preload("res://Sprites/9.png")
const ZeroSmall = preload("res://Sprites/0small.png")
const OneSmall = preload("res://Sprites/1small.png")
const TwoSmall = preload("res://Sprites/2small.png")
const ThreeSmall = preload("res://Sprites/3small.png")
const FourSmall = preload("res://Sprites/4small.png")
const FiveSmall = preload("res://Sprites/5small.png")
const SixSmall = preload("res://Sprites/6small.png")
const SevenSmall = preload("res://Sprites/7small.png")
const EightSmall = preload("res://Sprites/8small.png")
const NineSmall = preload("res://Sprites/9small.png")
const ZeroShadow = preload("res://Sprites/Shadow0.png")
const OneShadow = preload("res://Sprites/Shadow1.png")
const TwoShadow = preload("res://Sprites/Shadow2.png")
const ThreeShadow = preload("res://Sprites/Shadow3.png")
const FourShadow = preload("res://Sprites/Shadow4.png")
const FiveShadow = preload("res://Sprites/Shadow5.png")
const SixShadow = preload("res://Sprites/Shadow6.png")
const SevenShadow = preload("res://Sprites/Shadow7.png")
const EightShadow = preload("res://Sprites/Shadow8.png")
const NineShadow = preload("res://Sprites/Shadow9.png")
const ZeroSmallShadow = preload("res://Sprites/Shadow0small.png")
const OneSmallShadow = preload("res://Sprites/Shadow1small.png")
const TwoSmallShadow = preload("res://Sprites/Shadow2small.png")
const ThreeSmallShadow = preload("res://Sprites/Shadow3small.png")
const FourSmallShadow = preload("res://Sprites/Shadow4small.png")
const FiveSmallShadow = preload("res://Sprites/Shadow5small.png")
const SixSmallShadow = preload("res://Sprites/Shadow6small.png")
const SevenSmallShadow = preload("res://Sprites/Shadow7small.png")
const EightSmallShadow = preload("res://Sprites/Shadow8small.png")
const NineSmallShadow = preload("res://Sprites/Shadow9small.png")

# Spike configuration variables
var gap_in
var speed_in
var highest_in
var lowest_in
var position_in

# Instance of a room
var RoomInstance

# Save path
const SAVE_PATH = "user://savedata.save" 
const COUNT_PATH = "user://gamecount.save" 


func _ready():
	Transition.enter()
	display_highscore()
	$IntroSound.play()	


func reload():
	get_tree().reload_current_scene()
	
	
func save_high_score(score):
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	save_file.store_32(score)
	save_file.close()
	save_count()
	
	
func load_high_score():
	if FileAccess.file_exists(SAVE_PATH):
		var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var score = save_file.get_32()
		save_file.close()
		return score
	else:
		return 0
		
func save_count():
	var save_file = FileAccess.open(COUNT_PATH, FileAccess.WRITE)
	save_file.store_32(load_count() + 1)
	save_file.close()
	
	
func load_count():
	if FileAccess.file_exists(COUNT_PATH):
		var save_file = FileAccess.open(COUNT_PATH, FileAccess.READ)
		var score = save_file.get_32()
		save_file.close()
		return score
	else:
		return 0


# Adds a new room to the right
func add_room(points):
	
	# Corresponds to room number
	var pointsone = points + 1
	
	RoomInstance = RoomLoad.instantiate()
	RoomInstance.name = "Room" + str(pointsone)
	RoomInstance.set_global_position(Vector2((points) * 256, 0))
	
	randomize_positions(points + 1)
	
	var TileSetInstance
	
	if pointsone < 5:
		TileSetInstance = t1.instantiate()
	elif pointsone < 10:
		TileSetInstance = t2.instantiate()
	elif pointsone < 15:
		TileSetInstance = t3.instantiate()
	elif pointsone < 20:
		TileSetInstance = t5.instantiate()
	elif pointsone < 30:
		TileSetInstance = t4.instantiate()
	elif pointsone < 40:
		TileSetInstance = t8.instantiate()
	elif pointsone < 50:
		TileSetInstance = t6.instantiate()
	elif pointsone < 75:
		TileSetInstance = t7.instantiate()
	elif pointsone < 100:
		TileSetInstance = t9.instantiate()
	elif pointsone < 150:
		TileSetInstance = t10.instantiate()
	elif pointsone < 200:
		TileSetInstance = t11.instantiate()
	elif pointsone < 300:
		TileSetInstance = t12.instantiate()
	else :
		TileSetInstance = t13.instantiate()
		
		
		
	RoomInstance.add_child(TileSetInstance)
	
	# Add the room to the world
	self.add_child(RoomInstance)
	
	# Send the information to the spikes to update them
	get_node("/root/Main/ViewBox/ViewPort/World/" + RoomInstance.name + "/Big_Spikes").set_positions(gap_in, speed_in, highest_in, lowest_in, position_in)
	
	add_number(points)
	

# Removes a room to the left
func remove_room(points):
	
	get_node("/root/Main/ViewBox/ViewPort/World/Room" + str(points - 2)).queue_free()

func randomize_positions(points):

	var rand = RandomNumberGenerator.new()
	var rand_num
	
	# Set points_ten, which is 0 or points - 10, whichever is greater
	var points_ten : int = points - 10
	
	if points_ten < 0:
		points_ten = 0
		
	
	# Configure the gap between the spikes
	rand.randomize()
	rand_num = rand.randf_range(-5.0, 5.0)
	
	gap_in = 80.0 - (2 * points) + (1.5 * points_ten)
	
	if gap_in < 35.0:
		gap_in = 35.0
		
	gap_in += rand_num
	
	
	# Configure the spike speed
	rand.randomize()
	rand_num = rand.randf_range(-0.03, 0.03)
		
	speed_in = 0.2 + (0.04 * points) - (0.02 * points_ten)
	
	if speed_in > 1.0:
		speed_in = 1.0
		
	speed_in += rand_num
	
	
	# Configure the highest point the spike can reach
	rand.randomize()
	rand_num = rand.randf_range(-5.0, 5.0)
	
	highest_in = 30.0 + (0.03 * points) - (0.02 * points_ten)
	
	if highest_in > 80.0:
		highest_in = 80.0
	
	highest_in += rand_num
	
	
	# Configure the lowest point the spike can reach
	rand.randomize()
	rand_num = rand.randf_range(-5.0, 5.0)
	
	lowest_in = -30.0 - (0.03 * (points) + (0.02 * points_ten))
	
	if lowest_in < -80.0:
		lowest_in = -80.0
	
	lowest_in += rand_num
	
	
	# Configure the initial position of the spikes
	rand.randomize()
	rand_num = rand.randf_range(-10.0, 10.0)
	
	position_in = 10.0
	
	position_in += rand_num
	
func display_highscore():
	
	#save_high_score(0):
		
	var sprite
	var shadow
	var character
	
	# Central position of the displayed number
	var anchor = Vector2(-195, 92)
	
	# Space between the location of one digit and another
	const space : int = 15

	# Get score to display
	var high_score : int = load_high_score()
	
	var characters = str(high_score)
	
	# Get number of digits in this number
	var digits : int = len(characters)
	
	if digits >= 1:
		anchor.x -= (15 * digits) / 2 + 3
		get_node("Highscore_Screen").set_global_position(anchor)
	
	# Callibrate to the position of the first digit
	anchor.x += 139
	
	# Index of the string
	var index : int = 0
	
	while index < digits:
		
		character = characters[index]
		
		sprite = Sprite2D.new()
		shadow = Sprite2D.new()
		
		match character:
			'0':
				sprite.set_texture(ZeroSmall)
				shadow.set_texture(ZeroSmallShadow)
			'1':
				sprite.set_texture(OneSmall)
				shadow.set_texture(OneSmallShadow)
			'2':
				sprite.set_texture(TwoSmall)
				shadow.set_texture(TwoSmallShadow)
			'3':
				sprite.set_texture(ThreeSmall)
				shadow.set_texture(ThreeSmallShadow)
			'4':
				sprite.set_texture(FourSmall)
				shadow.set_texture(FourSmallShadow)
			'5':
				sprite.set_texture(FiveSmall)
				shadow.set_texture(FiveSmallShadow)
			'6':
				sprite.set_texture(SixSmall)
				shadow.set_texture(SixSmallShadow)
			'7':
				sprite.set_texture(SevenSmall)
				shadow.set_texture(SevenSmallShadow)
			'8':
				sprite.set_texture(EightSmall)
				shadow.set_texture(EightSmallShadow)
			'9':
				sprite.set_texture(NineSmall)
				shadow.set_texture(NineSmallShadow)
				
		sprite.set_centered(false)
		shadow.set_centered(false)
		
		add_child(sprite)
		add_child(shadow)
		
		# Set the position of the anchor
		sprite.set_position(anchor)
		sprite.z_index = 0
		
		anchor.x += 2
		anchor.y += 2
		
		shadow.set_position(anchor)
		sprite.z_index = 1
		
		anchor.x -= 2
		anchor.y -= 2
		
		# Move to the next sprite position
		anchor.x += space
		
		index += 1


func add_number(points):
	
	var sprite
	var shadow
	var character
	
	# Central position of the displayed number
	var anchor = Vector2(128, 28)
	
	# Space between the location of one digit and another
	const space : int = 24

	# Get number of room being made
	var points_one : int = points + 1
	
	var characters = str(points_one)
	
	# Get number of digits in this number
	var digits : int = len(characters)
	
	# Callibrate to the position of the first digit
	anchor.x = anchor.x - (digits - 1) * (space / 2)
	
	# Index of the string
	var index : int = 0
	
	while index < digits:
		
		character = characters[index]
		
		sprite = Sprite2D.new()
		shadow = Sprite2D.new()
		
		match character:
			'0':
				sprite.set_texture(Zero)
				shadow.set_texture(ZeroShadow)
			'1':
				sprite.set_texture(One)
				shadow.set_texture(OneShadow)
			'2':
				sprite.set_texture(Two)
				shadow.set_texture(TwoShadow)
			'3':
				sprite.set_texture(Three)
				shadow.set_texture(ThreeShadow)
			'4':
				sprite.set_texture(Four)
				shadow.set_texture(FourShadow)
			'5':
				sprite.set_texture(Five)
				shadow.set_texture(FiveShadow)
			'6':
				sprite.set_texture(Six)
				shadow.set_texture(SixShadow)
			'7':
				sprite.set_texture(Seven)
				shadow.set_texture(SevenShadow)
			'8':
				sprite.set_texture(Eight)
				shadow.set_texture(EightShadow)
			'9':
				sprite.set_texture(Nine)
				shadow.set_texture(NineShadow)
		
		RoomInstance.add_child(sprite)
		RoomInstance.add_child(shadow)
		
		# Set the position of the anchor
		sprite.set_position(anchor)
		sprite.z_index = 0
		
		anchor.x += 2
		anchor.y += 2
		
		shadow.set_position(anchor)
		shadow.z_index = -1
		
		anchor.x -= 2
		anchor.y -= 2
		
		# Move to the next sprite position
		anchor.x += space
		
		index += 1
		
