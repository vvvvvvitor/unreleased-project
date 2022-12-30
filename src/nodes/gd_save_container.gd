extends HBoxContainer

@onready var save_button = $SaveButton
@export var save_index:int = 0

var info:Dictionary
var hovering:bool = false

func _ready():
	save_button.mouse_entered.connect(_on_cursor_hover)
	save_button.mouse_exited.connect(_on_cursor_leave)
	
func _on_cursor_hover():
	hovering = true
	
func _on_cursor_leave():
	hovering = false
