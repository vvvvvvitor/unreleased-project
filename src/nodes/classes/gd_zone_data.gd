extends Resource
class_name ZoneData

@export var current_zone_pos:Vector2
@export var current_zone_ref:Zone:
	get: return current_zone_ref
	set(val):
		current_zone_ref = val
		current_zone_pos = current_zone_ref.position
