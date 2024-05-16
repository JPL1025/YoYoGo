extends Camera2D

func _process(_delta):
	
	var destination = Vector2(((get_node("/root/Main/ViewBox/ViewPort/World/Player").get_points()) * 256.0 - 128.0), 72.0)
	
	self.position = lerp (self.position, destination, 0.1)
