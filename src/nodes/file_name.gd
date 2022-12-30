extends LineEdit

func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_ENTER:
			if visible:
				if !text.is_empty() && text[0] != ' ':
					GlobalSaveSystem.make_file(text, get_parent().save_index)
					GlobalSaveSystem.load_file(get_parent().save_index)
					GlobalControl.change_scene("res://scenes/levels/0-0.tscn")
					GlobalSaveSystem.save_data['scene_path'] = "res://scenes/levels/0-0.tscn"
					GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])
				else: placeholder_text = 'Invalid name'
