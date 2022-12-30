extends Camera2D


@onready @export var target = get_parent()
@export_range(0, 1) var camera_smoothing:float = 0.15

@onready var box = $Box

var desired_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = target.position.x
	position.y = target.position.y
	
	#await get_tree().create_timer(1).timeout
	#GlobalEffects.draw_transition_show()
	print('a')
	
	top_level = true
	box.top_level = true
	position = target.global_position

	box.area_entered.connect(_on_box_entered)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target.position.x < box.position.x - 16 || target.position.x > box.position.x + 16:
		box.position.x = (round((target.position.x) / 16) * 16) + 8
	if target.position.y < box.position.y - 16 || target.position.y > box.position.y + 16:
		box.position.y = (round((target.position.y) / 16) * 16) + 8
	
	if GlobalControl.current_zone:
		position = lerp(position, desired_position, 0.15)
	else: 
		position = target.global_position

	
	if GlobalControl.current_zone:
		var shape = GlobalControl.current_zone.shape
 
		var limits_min = Vector2(
			shape.global_position.x - (shape.shape.size.x / 2) + (get_viewport_rect().size.x / 2), 
			shape.global_position.y - (shape.shape.size.y / 2) + (get_viewport_rect().size.y / 2)
			)
		
		var limits_max = Vector2(
			shape.global_position.x + (shape.shape.size.x / 2) - (get_viewport_rect().size.x / 2),
			shape.global_position.y + (shape.shape.size.y / 2) - (get_viewport_rect().size.y / 2)
		)
		
		desired_position.x = target.position.x
		desired_position.x = clamp(
			desired_position.x, 
			limits_min.x,
			limits_max.x)

		desired_position.y = target.position.y
		desired_position.y = clamp(
			desired_position.y,
			limits_min.y,
			limits_max.y)
	
	if target is CharacterBody2D:	
		if target.is_on_floor():
			if target.velocity.length() > 500:
				var floor_angle = atan2(target.get_floor_normal().x, -target.get_floor_normal().y)
				rotation = lerp_angle(rotation, floor_angle, 0.05)
			else: rotation = lerp_angle(rotation, 0, 0.05)
		else: rotation = lerp_angle(rotation, 0, 0.07)

func _on_box_entered(body):
	if body is Zone:
		if target.player_state != 4:
			GlobalControl.current_zone = body
			GlobalControl.current_zone_name = body.zone_name
