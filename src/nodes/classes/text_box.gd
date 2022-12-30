extends Node2D

var prompts:Array[String] = ['Lorem']
@onready var label = $ReferenceRect/Panel/MarginContainer/Label
var current_prompt = 0
var showing = false

@onready var show_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
@onready var hide_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)

func _ready():
	show_tween.stop()
	hide_tween.stop()
	
	show_tween.tween_property(self, 'scale', Vector2(1, 1), 0.2).set_trans(Tween.TRANS_QUAD)
	hide_tween.tween_property(self, 'scale', Vector2(0, 1), 0.2).set_trans(Tween.TRANS_QUAD)
	
	label.text = prompts[current_prompt]
	if !Engine.is_editor_hint():
		scale = Vector2(0, 1)

func _input(event):
	if visible:
		if event is InputEvent:
			if event.is_action_pressed("look_down"):
				new_prompt()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func show():
	current_prompt = 0
	label.text = prompts[current_prompt]
	hide_tween.stop()
	show_tween.play()
	visible = true
	await show_tween.finished
	show_tween.stop()

func hide():
	if get_tree():
		show_tween.stop()
		hide_tween.play()
		await hide_tween.finished
		visible = false 
		hide_tween.stop()

func new_prompt():
	if current_prompt < prompts.size() - 1:
		current_prompt += 1
		label.text = prompts[current_prompt]
	else: 
		hide()
