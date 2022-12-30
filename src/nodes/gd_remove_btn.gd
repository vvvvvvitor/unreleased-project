extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_btn_press)
	
func _on_btn_press():
	GlobalSaveSystem.remove_file(get_parent().save_index)
	get_parent().save_button.update_button()
