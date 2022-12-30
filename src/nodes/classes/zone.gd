@tool
extends Area2D
class_name Zone

@export var zone_name:String

var shape:CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		if node is CollisionShape2D:
			shape = node
			if Engine.is_editor_hint():
				shape.debug_color = Color(1, 0.45490196347237, 0, 0.5)
			break;

	if Engine.is_editor_hint():
		child_entered_tree.connect(_on_child_enter)
		

func _on_child_enter(node):
	if node is CollisionShape2D && node != shape:
		node.debug_color = Color(1, 0.45490196347237, 0, 0.5)
		node.shape = RectangleShape2D.new()
		node.shape.size = Vector2.ONE * 16
