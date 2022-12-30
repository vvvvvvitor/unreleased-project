extends Sprite2D

@onready @export var adjacent:Node2D = get_parent()
@export var gravity:float = 10
@export var max_distance:Vector2 = Vector2(3, 4)
var velocity:Vector2 = Vector2.ZERO

enum STATES {
	FOLLOWING,
	GRAVITY
}

var state = STATES.GRAVITY

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	position = get_parent().position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	scale = get_parent().scale
	
	if adjacent != owner:
		position.x = lerp(position.x, adjacent.global_position.x, 0.1)
		
		match state:
			STATES.GRAVITY:
				position.y = lerp(position.y, adjacent.global_position.y + (max_distance.y / 4), 0.2)
				
				position.y = clamp(position.y, adjacent.global_position.y - max_distance.y, adjacent.global_position.y + max_distance.y)
					
				position.x = lerp(position.x, adjacent.global_position.x, 0.2)
				
				position.x = clamp(position.x, adjacent.global_position.x - max_distance.x, adjacent.global_position.x + max_distance.x)

	else: global_position = get_parent().global_position

	position += velocity
