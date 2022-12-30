extends CharacterBody2D

@export var gravity = 80
var direction:Vector2 = Vector2.LEFT

@onready var sprite = $Sprite
var animation_time:float = 0

func _physics_process(delta):
	animation_time += delta * 16
	
	sprite.frame = int(animation_time) % sprite.hframes
	
	velocity.y += gravity * delta
	velocity.x = direction.x * 1500 * delta
	
	if is_on_floor():
		velocity.y -= 60
		
	if is_on_wall():
		direction.x = -direction.x
		
	move_and_slide()
