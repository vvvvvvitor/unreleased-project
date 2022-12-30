extends Button

@onready var file_name = $FileName
@onready var remove_btn = $"../RemoveBtn"

@export var save_index = 0
var loaded = false

var mouse_on_box = false
@onready var death_count = $"../DeathCountContainer/DeathCount"
@onready var death_count_container = $"../DeathCountContainer"


func _input(event):
	if event is InputEventMouseButton:
		if !mouse_on_box:
			if event.pressed:
				file_name.visible = false
				focus_mode = Control.FOCUS_ALL
				file_name.text = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	save_index = get_parent().save_index
	
	pressed.connect(_on_btn_press)
	file_name.mouse_exited.connect(_on_text_mouse_exit)
	file_name.mouse_entered.connect(_on_text_mouse_enter)
	
	update_button()

func update_button():
	var files = GlobalSaveSystem.get_files()

	if files.size() > 0:
		for file in files:
			if file.get('save_index', -1) == save_index:
				loaded = true
				text = file['save_name']
				death_count_container.visible = true
				death_count.text = str(file['deaths'])
				remove_btn.visible = true
				break
			else: 
				remove_btn.visible = false
				loaded = false
				death_count_container.visible = false
				text = '+'
	else:
		remove_btn.visible = false
		loaded = false
		death_count_container.visible = false
		text = '+'
	
func _on_btn_press():
	if loaded:
		var out = GlobalSaveSystem.load_file(save_index)
		if out:
			GlobalControl.change_scene(GlobalSaveSystem.save_data['scene_path'])
			disabled = true
		else: print('versioning_error')
	else: 
		file_name.visible = true
		focus_mode = Control.FOCUS_NONE

func _on_text_mouse_exit():
	mouse_on_box = false

func _on_text_mouse_enter():
	mouse_on_box = true
