extends Area2D
class_name HitBox

signal hit


func _ready():
	area_entered.connect(_on_area_entered)
	
func _on_area_entered(area):
	if area is HurtBox:
		emit_signal('hit', area)
		area.emit_signal('hit', self)
