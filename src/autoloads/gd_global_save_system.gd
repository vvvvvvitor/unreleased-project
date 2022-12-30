extends Node

const FOLDER_PATH = "user://cat/data/saves/"
const CURRENT_VERSION = 4

const SAVE_DATA_TEMPLATE:Dictionary = {
	'save_version': CURRENT_VERSION,
	'file_path': '',
	'save_name': '',
	'save_index': 0,
	'scene_path': '',
	'last_zone_pos': [0, 0],
	'deaths': 0
}

var save_data:Dictionary = SAVE_DATA_TEMPLATE.duplicate(true)

func _ready():
	if !DirAccess.dir_exists_absolute(FOLDER_PATH):
		DirAccess.make_dir_absolute(FOLDER_PATH)

func make_file(name:String, index:int):
	var copy = SAVE_DATA_TEMPLATE.duplicate(true)
	var file_path = FOLDER_PATH + 'cat_data' + str(index) + '.json'
	copy['save_index'] = index
	copy['save_name'] = name
	copy['file_path'] = file_path
	var json_str = JSON.stringify(copy)
	var file = FileAccess.open(file_path, FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		return true
	return false

func remove_file(index:int):
	var files = get_files()
	for file in files:
		if file.get('save_index', -1) == index:
			DirAccess.remove_absolute(file['file_path'])

func save_file(index:int) -> bool:
	var json_str = JSON.stringify(save_data)
	var file = FileAccess.open(FOLDER_PATH + 'cat_data' + str(index) + '.json', FileAccess.WRITE)
	if file:
		file.store_string(json_str)
		return true
	return false

	
func load_file(index:int = 0) -> bool:
	var files = get_files()
	for file in files:
		if file['save_index'] == index:
			save_data = file
			return true
	return false

func check_file(index:int = 0) -> bool:
	return FileAccess.file_exists(FOLDER_PATH + 'cat_data' + str(index) + '.json')

func get_files() -> Array:
	var out_files = []
	var files = DirAccess.get_files_at(FOLDER_PATH)
	for file_name in files:
		if file_name.ends_with('.json'):
			var file = FileAccess.open(FOLDER_PATH + file_name, FileAccess.READ)
			var contents = file.get_as_text()
			var parsed_file = JSON.parse_string(contents)
			if parsed_file.has_all(SAVE_DATA_TEMPLATE.keys()):
				if parsed_file.get('save_version', -1) == CURRENT_VERSION:
					out_files.append(parsed_file)
	return out_files
