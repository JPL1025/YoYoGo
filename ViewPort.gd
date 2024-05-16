extends SubViewport

func configure_display(game_size):
	
	game_size.x /= 2
	game_size.y /= 2
	
	set_size(game_size)
	
