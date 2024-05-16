extends Area2D

# How much space is between the two spikes?
var gap : float = 80.0

# Do the spikes move?
var speed : float = 0.2

const SPEED_MULTIPLIER : float = 2

# If the top of the lower spike reaches these coordinates, go the other direction
var highest_y : float = 30.0
var lowest_y : float = -30.0

# Relative position
var position_gen : float = 10.0
var position_lower : float
var position_upper : float

# Called when the node enters the scene tree for the first time.
func _ready():
	
	update_positions()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	position_gen += speed * SPEED_MULTIPLIER
	
	update_positions()
	
	# If general position is out of bounds, reverse spike trajectory
	if (position_gen > highest_y || position_gen < lowest_y):
		speed *= -1.0
	
# Updates the positions of the sprites and collision boxes
func update_positions():
	
	position_lower = 135.0 + position_gen
	position_upper = -135.0 - gap + position_gen
	
	# It just works
	get_node("BottomSpikeSprite").set_position(Vector2(8, position_lower))
	get_node("BottomSpikeCollision").set_position(Vector2(8, position_lower + 1.0))
	
	get_node("UpperSpikeSprite").set_position(Vector2(8, position_upper))
	get_node("UpperSpikeCollision").set_position(Vector2(7, position_upper - 1.0))
	
func set_positions(gap_in, speed_in, highest_in, lowest_in, position_in):
	gap = gap_in
	speed = speed_in
	highest_y = highest_in
	lowest_y = lowest_in
	position_gen = position_in
