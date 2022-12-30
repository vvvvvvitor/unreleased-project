extends CharacterBody2D
class_name Player

enum PLAYER_STATES {
	IDLE,
	MOVING,
	FALLING,
	JUMPING,
	DEAD
}

var last_state = PLAYER_STATES.IDLE
signal player_state_changed
@export var player_state = PLAYER_STATES.IDLE:
	get: return player_state
	set(value):
		last_state = player_state
		if player_state != value:
			emit_signal('player_state_changed', player_state, value)
		player_state = value

var last_position_standing:Vector2 = Vector2.ZERO

@export var ground_speed:int = 150
@export var ground_friction:int = 4
@export var gravity:int = 650
@export var jump_force:int = 250

var last_direction:Vector2 = Vector2.RIGHT
@onready var sprite:Sprite2D = $Sprite
@onready var shape = $Shape
@onready var respawn_timer = $RespawnTimer
@onready var bomb_use_timer = $BombUseTimer
@onready var coyote_timer = $CoyoteTimer
@onready var hit_box:HitBox = $HitBox

@export var loop_treshold = 500

@onready var offset:float = (-sprite.texture.get_height() / 8) * scale.y

func _ready():
	colliding.connect(_on_collision)
	position.x = GlobalSaveSystem.save_data['last_zone_pos'][0]
	position.y = GlobalSaveSystem.save_data['last_zone_pos'][1]
	
	hit_box.hit.connect(_on_enemy_hit)

func _input(event):
	if event is InputEvent:
		if event.is_action_pressed("action_secondary"):
			spawn_bomb()
		

func spawn_bomb() -> void:
	if bomb_use_timer.is_stopped():
		var bomb = load("res://scenes/ticking_bomb.tscn").instantiate()
		bomb.position = position + Vector2(0, offset)
		var look = Vector2(Input.get_axis("look_left", "look_right"), Input.get_axis("look_up", "look_down"))
		if look.length() > 0:
			bomb.velocity = look.normalized() * ground_speed
		else: bomb.velocity = global_position.direction_to(get_global_mouse_position()) * ground_speed
		get_tree().get_current_scene().add_child(bomb)
		bomb_use_timer.start()
signal colliding

func _physics_process(delta):
	if get_slide_collision_count() > 0:
		emit_signal('colliding', get_last_slide_collision())

	var horizontal_movement = Input.get_axis("move_left", 'move_right')
	var vertical_look = Input.get_axis("look_up", 'look_down')
	var direction = Vector2(horizontal_movement, vertical_look)
	
	var jump = Input.is_action_just_pressed("action_main")

	if direction.length() != 0:
		last_direction = direction

	if velocity.length() > 500:
		floor_max_angle = PI
	else: 
		floor_max_angle = deg_to_rad(64)
		if get_floor_normal().y >= 0:
			move(Vector2(get_floor_normal().x, get_floor_normal().y), ground_speed, delta)

	match player_state:
		PLAYER_STATES.IDLE:
			if horizontal_movement != 0:
				player_state = PLAYER_STATES.MOVING
			else: apply_friction(ground_friction, delta)
			if !is_on_floor():
				coyote_timer.start()
				player_state = PLAYER_STATES.FALLING
				
			if jump:
				GlobalEffects.create_particle(GlobalEffects.SMALL_SMOKE, position - Vector2(0, 4))
				player_state = PLAYER_STATES.JUMPING
				move(get_floor_normal(), jump_force)

		PLAYER_STATES.MOVING:
			up_direction = lerp(up_direction, get_floor_normal(), 0.5) if abs(velocity.x) > 50 else Vector2.UP
			move(Vector2(horizontal_movement * -ceil(get_floor_normal().y) if -ceil(get_floor_normal().y) != 0 else horizontal_movement, 0), ground_speed if velocity.normalized().x == horizontal_movement else ground_speed * ground_friction, delta)
			#move(-get_floor_normal(), ground_speed if velocity.normalized().x == horizontal_movement else ground_speed * ground_friction, delta)
			if horizontal_movement == 0:
				player_state = PLAYER_STATES.IDLE
				
			if is_on_wall():
				apply_friction(ground_friction, delta)
				
			if !is_on_floor():
				coyote_timer.start()
				player_state = PLAYER_STATES.FALLING

			if jump:
				GlobalEffects.create_particle(GlobalEffects.SMALL_SMOKE, position - Vector2(0, 4))
				
				player_state = PLAYER_STATES.JUMPING
				move(get_floor_normal(), jump_force)
				
		PLAYER_STATES.FALLING:
			up_direction = Vector2.UP
			
			move(Vector2(horizontal_movement, 0), ground_speed, delta)
			move(Vector2(0, 1), gravity, delta)
			
			if is_on_floor():
				player_state = PLAYER_STATES.MOVING
				
		PLAYER_STATES.JUMPING:
			move(Vector2(horizontal_movement, 0), ground_speed, delta)
			move(Vector2(0, 1), gravity, delta)
			
			rotation = 0
			
			if Input.is_action_just_released("action_main") || velocity.y > 0:
				velocity.y /= 1.5
				player_state = PLAYER_STATES.FALLING
				
			if is_on_floor():
				player_state = PLAYER_STATES.MOVING
				
		PLAYER_STATES.DEAD:
			if is_on_floor():
				apply_friction(ground_friction, delta)
			move(Vector2(0, 1), gravity, delta)
			if respawn_timer.is_stopped():
				respawn_on_zone(GlobalControl.current_zone)

	
	move_and_slide()
	
func move(direction:Vector2 = Vector2.ZERO, speed = 1, delta:float = 1.0) -> void:
	velocity += direction * speed * delta
	
func apply_friction(multiplier:int = 1, delta:float = 1.0) -> void:
	velocity -= velocity * multiplier * delta
	
func respawn(new_position):
	position = new_position
	velocity = Vector2.ZERO
	player_state = PLAYER_STATES.MOVING
	GlobalEffects.create_particle(GlobalEffects.SMALL_SMOKE, position - Vector2(0, 4))
	hit_box.monitoring = true
	hit_box.monitorable = true
	
	
func respawn_on_zone(zone:Zone):
	respawn(zone.position if zone else last_position_standing)

func _on_enemy_hit(body):
	if player_state != PLAYER_STATES.DEAD:
		hit_box.monitoring = false
		hit_box.monitorable = false
	
		velocity.y = 0
		GlobalEffects.create_particle(GlobalEffects.SMALL_SMOKE, position - Vector2(0, 4))
		player_state = PLAYER_STATES.JUMPING
		move(Vector2.UP, jump_force * 1.5)

func _on_collision(collider):
	print(collider.get_collider())
	
	if collider.get_collider() is TileMap:
		var tile_map = collider.get_collider()
		var tile_position = tile_map.local_to_map(position + (collider.get_normal() * Vector2(-2, -1)))
		if tile_map.get_cell_tile_data(1, tile_position, false):
			if tile_map.get_cell_tile_data(1, tile_position, false).get_custom_data('Hazard'):
				move(-collider.get_normal(), -400, 1)
				if player_state != PLAYER_STATES.DEAD:
					respawn_timer.start()
					player_state = PLAYER_STATES.DEAD
					GlobalControl.deaths += 1
				GlobalEffects.call_freeze(0.2)
			else:
				if player_state != PLAYER_STATES.DEAD:
					if !is_on_wall():
						last_position_standing = position
