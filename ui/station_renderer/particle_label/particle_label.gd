extends Label
class_name ParticleLabel

enum FLOAT_DIRECTIONS {
	LEFT,
	CENTER,
	RIGHT
}

var floatDirection : int = FLOAT_DIRECTIONS.LEFT

func _ready() -> void:
	pivot_offset = size/2
	var floatX
	match floatDirection:
		FLOAT_DIRECTIONS.LEFT:
			floatX = -1
		FLOAT_DIRECTIONS.CENTER:
			floatX = 0
		FLOAT_DIRECTIONS.RIGHT:
			floatX = 1

	var particleLabelTween = get_tree().create_tween()
	particleLabelTween.set_parallel(true)
	particleLabelTween.tween_property(self, "scale", Vector2(0.7,0.7), 0.2)
	particleLabelTween.tween_property(self, "scale", Vector2.ZERO, 0.3).set_delay(0.2)
	particleLabelTween.tween_property(self,"position",global_position + Vector2(40*floatX, -80),2.0)
	await particleLabelTween.finished
	queue_free()
