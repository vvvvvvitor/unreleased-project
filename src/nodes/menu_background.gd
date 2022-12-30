extends Sprite2D

func _process(delta):
	position = (texture.get_size() / 2) + (-(texture.get_size() / 4) + get_global_mouse_position() * 0.1)
