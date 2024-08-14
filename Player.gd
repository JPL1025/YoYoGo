extends CharacterBody2D

const UP = Vector2.UP
const GRAV = 1.2
const TOP = 7.0

enum State {TITLE, START, LEAP, SWING, FALL, DEAD, DEBUG}

var current_state = State.TITLE
var points : int = 0

var init_glob_pos

# Direction variables
var veloc = Vector2.ZERO


func _ready():
	
	# Get initial position so we can reset the position later
	init_glob_pos = get_global_position()
	#$PlayerSprite.play("Start")
	draw_web_start()
	
	# Load the ad to be played after death
	#get_node("/root/Main/Interstitial")._on_load_pressed()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	
	match current_state:
		State.TITLE:
			state_title()
		State.START:
			state_start()
		State.LEAP:
			state_leap()
		State.SWING:
			state_swing()
		State.FALL:
			state_fall()
		State.DEAD:
			state_dead()
		State.DEBUG:
			state_debug()
	
	set_velocity(veloc)
	
	move_and_slide()
	
func state_debug():
	pass

func state_title():
	veloc = Vector2.ZERO
	

# For now the same as leap, but may limit user input and play an animation in more finished builds
func state_start():
	veloc = Vector2.ZERO
	check_pressed()
		
	check_bounds()
	
	
func state_leap():
	veloc.y += GRAV
	check_pressed()
	hide_web()
	
	if points < int((get_position().x + 18) / 256) + 1:
		change_points()
		
	check_bounds()
	
	
func state_swing():
	
	var points_ten = points - 10
	
	if points_ten < 0:
		points_ten = 0
	
	# Speed of swinging. Will later be based on an equation based on the amount of points
	var swing_speed = 120 + (5 * points) - (3 * points_ten)
	
	# Get the relative position vector between 
	var rel_vector = get_global_position() - get_node("/root/Main/ViewBox/ViewPort/World/Room" + str(points) + "/Peg").get_global_position()
	
	# Get the perpendicular vector
	var vector_temp = -rel_vector.x
	rel_vector.x = rel_vector.y
	rel_vector.y = vector_temp
	
	veloc = rel_vector.normalized() * swing_speed
	
	borderize()
	
	draw_web_leap()
	
	check_released()
	
	check_bounds()
	
	
# Acts like leap, but player cannot do anything as they are doomed to die
func state_fall():
	veloc.y += GRAV * 2
	check_bounds()


func state_dead():
	veloc.y += GRAV * 2
	check_over()


# Returns the amount of points the player has
func get_points():
	return points
		
	
func change_points():
	
	#get_node("/root/Main/Banner").banner_destroy()
	
	points = int((get_global_position().x + 18) / 256) + 1

	# Update scoreboard as well	
	var digits : int = str(points).length()
	
	# Instance new room 
	if points >= 1:
		get_node("/root/Main/ViewBox/ViewPort/World").add_room(points)
	
	# Free old rooms
	if points >= 3:
		get_node("/root/Main/ViewBox/ViewPort/World").remove_room(points)
	
	
func check_pressed():
	if (current_state == State.LEAP && Input.is_action_just_pressed("ui_hold")):
		current_state = State.SWING
		$WebSound.play(0.0)
	elif (current_state == State.START && Input.is_action_just_pressed("ui_hold")):
		current_state = State.LEAP
		hide_web()
	

func check_released():
	if Input.is_action_just_released("ui_hold"):
		current_state = State.LEAP
		hide_web()
	
func check_bounds():
	# Switches to "DEAD" once player has fallen onto the spikes
	if get_global_position().y >= 130:
		#$PlayerSprite.play("Dead")
		veloc.y = -70
		veloc.x = 0
		
		$DeathSound.play()
				
		current_state = State.DEAD
		
		$Crack.visible = true
		hide_web()
		
	if get_global_position().y < TOP:
		$ImpactCeilingSound.play()
		veloc.y = abs(veloc.y)
		
	check_over()


# Save High Score and go back to the title screen
func check_over():
	if get_global_position().y >= 160:
		if points > get_node("/root/Main/ViewBox/ViewPort/World").load_high_score():
			get_node("/root/Main/ViewBox/ViewPort/World").save_high_score(points)
		Transition.reload()


# Draw a web from the player's position to the position of the peg in the current room
func draw_web_leap():
	var point1 = Vector2.ZERO
	var point2 = (get_node("/root/Main/ViewBox/ViewPort/World/Room" + str(points) + "/Peg").get_global_position() - get_position())
	
	$Web.points = [point1, point2]
	
	point1.x += 2
	point1.y += 2
	point2.x += 2
	point2.y += 2
	
	$WebShadow.points = [point1, point2]
	
	
func draw_web_start():
	var ceiling_anchor = get_node("/root/Main/ViewBox/ViewPort/World/Room1").get_global_position() - get_position()
	ceiling_anchor.x = 0.0
	
	var point1 = Vector2.ZERO
	var point2 = ceiling_anchor

	$Web.points = [point1, point2]
	
	point1.x += 2
	point1.y += 2
	point2.x += 2
	point2.y += 2
	
	$WebShadow.points = [point1, point2]
	
	
func hide_web():
	$Web.points = [Vector2.ZERO, Vector2.ZERO]
	$WebShadow.points = [Vector2.ZERO, Vector2.ZERO]


func _on_Area2D_area_entered(area):
	if (area.name == "Big_Spikes" && current_state != State.DEAD):
		#$PlayerSprite.play("Fall")
		veloc.x *= -0.5
		if current_state == State.SWING:
			veloc.y = abs(veloc.y)
		
		$ImpactSpikeSound.play()
		
		current_state = State.FALL
		$Crack.visible = true
		
		if (veloc.x < 10):
			if (veloc.x > 0):
				veloc.x = 10
			elif (veloc.x > -10):
				veloc.x = -10
				
		hide_web()
		
# Manually forces the player to slide against the top of the screen when swinging if it swings against the ceiling
func borderize():
	if position.y + (veloc.y/60.0) < TOP:
		veloc.y = (TOP - position.y) * 60
	
func _on_start_button_button_up():
	
	get_node("/root/Main/ViewBox/ViewPort/World/Room1/UI/StartButton/PressedButton").visible = false
	
	$ButtonReleased.play()
	
	#get_node("/root/Main/Banner").banner_destroy()
	
	if points < 1:
		points = 1 
		current_state = State.START
		
		
func _on_start_button_button_down():
	
	get_node("/root/Main/ViewBox/ViewPort/World/Room1/UI/StartButton/PressedButton").visible = true
	
	$ButtonClicked.play()
