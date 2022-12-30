extends CharacterBody2D

const EXPLOSION_TIME = 3
const AIR_FRICTION = 0.95

@onready var explosion_timer = $ExplosionTimer
@onready var sprite = $Sprite

var ticking_cycle:float = 0
var before_velocity:Vector2 = velocity

func _unhandled_input(event):
	if event is InputEvent:
		if event.is_action_released("action_secondary"):
			explode()

func _ready():
	explosion_timer.start()
	explosion_timer.timeout.connect(_on_explosion)
	
func _physics_process(delta):
	var time_past = (explosion_timer.wait_time - explosion_timer.time_left)
	
	velocity *= AIR_FRICTION
	ticking_cycle = fmod((ticking_cycle + ((time_past * time_past) * 100)) * delta, 2.0)
	sprite.frame = int(ticking_cycle)
	
	if is_on_floor() || is_on_ceiling() || is_on_wall():
		velocity = before_velocity.bounce(get_floor_normal())
	else: before_velocity = velocity
		
	move_and_slide()


func _on_explosion():
	explode()

func explode() -> void:
	GlobalEffects.create_particle(GlobalEffects.SMALL_EXPLOSION, global_position)
	
	var explosion = Explosion.new()
	explosion.position = position + Vector2(0, 5)
	explosion.explosion_strength = 400
	explosion.explosion_radius = 30
	get_tree().get_current_scene().add_child(explosion)
	queue_free()
