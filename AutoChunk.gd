extends Node2D

const HOUSE = preload("res://HouseThatchedRoof.tscn")

var chunk_id = null

# cheater tips https://godotengine.org/qa/24745/how-to-check-type-of-a-custom-class
func is_class(c): return c == "AutoChunk" or .is_class(c)
func get_class(): return "AutoChunk"

func _init(chunk_id):
	self.chunk_id = chunk_id
	print("auto chunk id %d" % chunk_id)
	add_child(HOUSE.instance())
