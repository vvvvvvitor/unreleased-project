extends Node2D

var cursor_sprite:Texture2D
var font = Label.new().get_theme_font('')
var current_scene_path:String:
	get: return current_scene_path
	set(val):
		if val is String:
			current_scene_path = val
			GlobalSaveSystem.save_data['scene_path'] = val

var current_zone:Zone:
	get: return current_zone
	set(val):
		current_zone = val
		if current_zone is Zone:
			GlobalSaveSystem.save_data['last_zone_pos'] = [val.position.x, val.position.y]
		else: GlobalSaveSystem.save_data['last_zone_pos'] = [0, 0]
		GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])

var current_zone_name:String

var deaths:int:
	get: return deaths
	set(val):
		deaths = val
		GlobalSaveSystem.save_data['deaths'] = val
		print(deaths)
		GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])

func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_pressed("look_up"):
			GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])

func _ready():
	z_index = 100
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	#var cursor_image = Image.new()
	#cursor_image.load("res://src/data/sprites/crosshair.png")
	#cursor_sprite = ImageTexture.new().create_from_image(cursor_image)

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("bind_fullscreen"):
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED)

func _process(_delta):
	queue_redraw()
	
func _draw():
	#if get_viewport().get_camera_3d():
	#	draw_line(get_viewport().get_camera_2d().target.position - Vector2(0, 12), get_local_mouse_position(), Color(1, 1, 1, 0.5), 2)
	#draw_texture(cursor_sprite, get_local_mouse_position() - Vector2(cursor_sprite.get_width() / 2, cursor_sprite.get_height() / 2))
	draw_circle(get_global_mouse_position(), 4, Color.WHITE)
	draw_circle(get_global_mouse_position(), 2, Color.BLACK)
	#pass

func change_scene(path:String):
	GlobalEffects.draw_transition_show()
	await GlobalEffects.transition_finished
	get_tree().change_scene_to_file(path)
	GlobalEffects.draw_transition_hide(2)
	current_scene_path = path
	GlobalSaveSystem.save_file(GlobalSaveSystem.save_data['save_index'])
