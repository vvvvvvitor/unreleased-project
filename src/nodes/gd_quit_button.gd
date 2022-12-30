extends ActedButton


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_button_press)
	
func _on_button_press():
	GlobalEffects.draw_transition_show()
	await  GlobalEffects.transition_finished
	get_tree().quit(0)
