extends SubViewportContainer

var screen : Vector2				# Screen/window resolution 
var game_set : Vector2				# Preconfigured logical game resolution
var game_config : Vector2			# Adjusted logical game resolution
var screen_aspect_ratio : float		# Aspect ratio of screen/window
var game_set_aspect_ratio : float	# Aspect ratio of preconfigured logical game resolution

# Configures the game view when starting up
func _ready():
	
	game_set = get_size()
	configure_display()

# Changes size dynamically every frame - only for testing!
# func _process(delta):
	# configure_display()
	
func configure_display():
	
	screen = get_window().get_size()
	
	screen_aspect_ratio = screen.x/screen.y
	game_set_aspect_ratio = game_set.x/game_set.y
	
	# The screen is taller (in landscape) than 16:9
	if screen_aspect_ratio < game_set_aspect_ratio:
		game_config.x = game_set.x
		game_config.y = int(game_set.x / screen_aspect_ratio)
		
	# The screen is 16:9 or is wider (in landscape) than 16:9
	else:
		game_config.x = int(game_set.y * screen_aspect_ratio)
		game_config.y = game_set.y
	
	set_size(game_config)
	
	$ViewPort.configure_display(game_config)
