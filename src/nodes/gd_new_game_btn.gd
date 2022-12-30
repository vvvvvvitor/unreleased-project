extends Button

@onready var line_edit = $"../LineEdit"

# Called when the node enters the scene tree for the first time.
func _ready():
	pressed.connect(_on_btn_press)
	
func _on_btn_press():
	#GlobalSaveSystem.make_file(line_edit.text)
	GlobalSaveSystem.load_file(GlobalSaveSystem.get_files().size() - 1)
	GlobalControl.change_scene("res://scenes/levels/0-0.tscn")
	GlobalSaveSystem.save_data['scene_path'] = "res://scenes/levels/0-0.tscn"
	GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])
