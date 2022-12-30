extends Button
class_name ActedButton

func _ready():
	pivot_offset = size / 2
	button_down.connect(__on_button_press)
	button_up.connect(__on_button_release)

func __on_button_press():
	scale = Vector2.ONE * 0.9
	
func __on_button_release():
	scale = Vector2.ONE
