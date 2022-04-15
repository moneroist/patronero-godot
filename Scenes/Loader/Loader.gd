extends TextureRect

func _ready() -> void:
	_spin()

func _on_Tween_tween_all_completed():
	_spin()

func _spin() -> void:
	$Tween.interpolate_property(self, "rect_rotation", 0, 360, 1)
	$Tween.start()

func _on_Loader_resized():
	rect_pivot_offset = Vector2(rect_size.x/2, rect_size.y/2)
