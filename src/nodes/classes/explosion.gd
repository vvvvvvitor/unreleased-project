extends Area2D
class_name Explosion

@export var explosion_strength:float = 200
@export var explosion_radius:float = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	shape.shape.radius = explosion_radius
	add_child(shape)
	
	body_entered.connect(_on_body_entered)
	set_collision_layer_value(4, true)
	set_collision_layer_value(0, false)
	set_collision_mask_value(0, false)
	set_collision_mask_value(2, true)
	
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _on_body_entered(body):
	if body is Player:
		body.velocity = global_position.direction_to(body.shape.global_position) * explosion_strength
		queue_free()
