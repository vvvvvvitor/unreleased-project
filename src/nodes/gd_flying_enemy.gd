extends Enemy

@onready var hurt_box = $HurtBox
@onready var sprite = $Sprite
@onready var animation_tree = $Sprite/AnimationTree
@onready var animation_states = animation_tree.get("parameters/playback")

@export var radius:Vector2 = Vector2.ONE
@export var speed:float = 1
var time:float = 0

var active = true

func _ready():
	hurt_box.hit.connect(_on_hit)

func _physics_process(delta):
	if active:
		time += 0.1
		velocity.x = sin(time * speed) * (radius.x * speed)
		velocity.y = cos(time * speed) * (radius.y * speed)
	else: velocity = Vector2.ZERO
	
	move_and_slide()

func _on_hit(body):
	active = false
	hurt_box.monitorable = false
	hurt_box.monitoring = false
	animation_states.travel('Deactivate')
	await get_tree().create_timer(1).timeout
	active = true
	hurt_box.monitoring = true
	hurt_box.monitorable = true
	animation_states.travel('Reactivate')
