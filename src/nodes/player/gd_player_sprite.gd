extends Sprite2D

@onready var parent = get_parent()
@onready var tail = $Tail

@onready var animation_player = $AnimationPlayer

@onready var animation_tree = $AnimationTree

@onready var animation_states = animation_tree.get("parameters/playback")
var current_node:String

@onready var player:Player = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	top_level = true
	get_parent().player_state_changed.connect(_on_player_state_changed)

########### Try doing proceduraal tail


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var floor_angle = atan2(get_parent().get_floor_normal().x, -get_parent().get_floor_normal().y) 
	
	current_node = animation_states.get_current_node()
	#print(current_node)
	if current_node == 'Falling':
		scale.x = 1 - (player.velocity.y / 2000)
		pass
	if current_node == 'JumpingBetween':
		scale = lerp(scale, Vector2.ONE, 0.5)
	if current_node in ['Walking', 'Idle']:
		animation_tree["parameters/Walking/TimeScale/scale"] = clamp(abs(player.velocity.x) / 100, 1, 100)
		scale.x = lerp(scale.x, 1 + abs(player.velocity.x / 2000), 0.5)
		scale.y = lerp(scale.y, 1 -  abs(player.velocity.x / 2500), 0.5)
		
	if parent.is_on_floor():
		if parent.velocity.x * -floor(parent.get_floor_normal().y) < 0:
			flip_h = true
			tail.position.x = 2
		else: 
			flip_h = false
			tail.position.x = -2
		position = get_parent().global_position if get_parent().get_floor_normal().y < 0 else get_parent().global_position - Vector2(0, texture.get_height() / (vframes * 2))
	else:
		
		position = get_parent().global_position
		
	rotation = lerp_angle(rotation, floor_angle, 0.5) if get_parent().is_on_floor() else lerp_angle(rotation, 0.0, 0.05) 
	

func _on_player_state_changed(old_state, new_state):
	match new_state:
		0: animation_states.travel('Idle')
		1: animation_states.travel('Walking')
		2: animation_states.travel('Falling')
		3: animation_states.travel('JumpingUp')
		4: animation_states.travel('Dead')
