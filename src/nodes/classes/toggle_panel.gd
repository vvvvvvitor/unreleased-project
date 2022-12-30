extends Panel
class_name TogglePanel

@export var target:Button

@onready var show_tween = get_tree().create_tween()
@onready var hide_tween = get_tree().create_tween()

enum ANIMATION_DIRECTION {
	ANIMATION_DIRECTION_TOP_CENTER,
	ANIMATION_DIRECTION_BOTTOM_CENTER
}

@export var animation_direction:ANIMATION_DIRECTION = ANIMATION_DIRECTION.ANIMATION_DIRECTION_BOTTOM_CENTER

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	
	match animation_direction:
		ANIMATION_DIRECTION.ANIMATION_DIRECTION_BOTTOM_CENTER:
			pivot_offset = size * Vector2(0.5, 1)
		ANIMATION_DIRECTION.ANIMATION_DIRECTION_TOP_CENTER:
			pivot_offset = size * Vector2(0.5, 0)
	
	if target:
		target.button_down.connect(_on_btn_press)
	elif get_parent() is Button: get_parent().button_down.connect(_on_btn_press)
	visibility_changed.connect(_on_visible_change)

func _on_btn_press():
	var show_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)
	var hide_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)
	
	show_tween.stop()
	hide_tween.stop()
	
	show_tween.tween_property(self, 'scale', Vector2.ONE, 0.1).set_trans(Tween.TRANS_QUAD)
	hide_tween.tween_property(self, 'scale', Vector2.ZERO, 0.1).set_trans(Tween.TRANS_QUAD)
	hide_tween.tween_property(self, 'visible', false, 0)
	
	if visible:
		hide_tween.play()
		return
	if !visible:
		scale = Vector2.ZERO
		visible = true
		show_tween.play()
		return
		
func _on_visible_change():
	if !get_parent().visible:
		visible = false
