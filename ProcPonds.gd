# Generates a number of ponds, obeying
# proc zone placement
extends Node2D

export var num_ponds = 1
export var max_size = Vector2(512,512)

const min_size = Vector2(64,64)

const AutoPond = preload("res://AutoPond.tscn")

var _manifest = {}
func set_manifest(mfst: Dictionary):
	self._manifest = mfst

func _ready():
	for i in range(num_ponds):
		var pond = AutoPond.instance()
		if _manifest == null || _manifest.empty():
			pond.size = Vector2(max(min_size.x,randi()%int(max_size.x)),
								max(min_size.y,randi()%int(max_size.y)))
		else:
			pond.set_manifest(_manifest)
		add_child(pond)
	_manifest.clear()
