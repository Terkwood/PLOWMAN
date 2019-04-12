extends RichTextLabel

const _DISAPPEAR_AT = 888
var _counter = 0
func _physics_process(_delta):
	_counter += 1
	if _counter > _DISAPPEAR_AT:
		get_parent().remove_child(self)
		self.queue_free()
