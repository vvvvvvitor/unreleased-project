extends Node2D

@export var prompts:Array[String]
@onready var area = $Area
@onready var text_box = $TextBox


# Called when the node enters the scene tree for the first time.
func _ready():
	text_box.prompts = prompts
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_body_entered(body):
	if body is Player:
		text_box.show()
		
func _on_body_exit(body):
	if body is Player:
		text_box.hide()
