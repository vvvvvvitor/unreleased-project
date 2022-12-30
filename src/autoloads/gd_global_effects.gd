extends Control

enum {
	SMALL_SMOKE,
	SMALL_EXPLOSION
}

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	z_index = 100

func call_freeze(duration:float = 0.4):
	get_tree().paused = true
	await get_tree().create_timer(duration).timeout
	get_tree().paused = false

var smoke = load("res://scenes/particles/smoke.tscn")
var explosion = load("res://scenes/particles/sc_explosion_particle.tscn")

func create_particle(particle:int, position:Vector2 = Vector2.ZERO) -> void:
	match particle:
		SMALL_SMOKE:
			var smoke_instance = smoke.instantiate()
			smoke_instance.position = position
			smoke_instance.emitting = true
			get_tree().get_current_scene().add_child(smoke_instance)
			
		SMALL_EXPLOSION:
			var explosion_instance = explosion.instantiate()
			explosion_instance.position = position
			explosion_instance.emitting = true
			get_tree().get_current_scene().add_child(explosion_instance)

var camera:Camera2D
var display_size:Vector2
var transition_alpha:int = 0

signal transition_finished

func draw_transition_hide(duration:float = 1.0):
	transition_alpha = 255
	
	var transition_hide_tween = get_tree().create_tween().set_ease(Tween.EASE_IN)

	transition_hide_tween.tween_property(self, 'transition_alpha', 0, duration).set_trans(Tween.TRANS_QUAD)
	await transition_hide_tween.finished
	emit_signal('transition_finished')
	
func draw_transition_show(duration:float = 1.0):
	var transition_show_tween = get_tree().create_tween().set_ease(Tween.EASE_OUT)

	transition_show_tween.stop()

	transition_show_tween.tween_property(self, 'transition_alpha', 255, duration).set_trans(Tween.TRANS_QUAD)
	
	transition_show_tween.play()
	await transition_show_tween.finished
	emit_signal('transition_finished')
	
func _process(delta):
	queue_redraw()
	camera = get_viewport().get_camera_2d()
	if camera: position = camera.position
	else: position = display_size / 2
	display_size = Vector2(get_viewport_rect().size.x, get_viewport_rect().size.y)

func _draw():
	#if camera:
	draw_rect(Rect2(-display_size, display_size * 4), Color8(0, 0, 0, transition_alpha), true)
	#else: draw_rect(Rect2(Vector2.ZERO, display_size), Color8(0, 0, 0, transition_alpha), true)
	#draw_rect(Rect2(0, 0, 10, 10), Color.WHITE, true)
	
	
	
	
	
	
	
	
	
	
	
	
