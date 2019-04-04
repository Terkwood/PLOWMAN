extends Node2D

const HOUSE = preload("res://HouseThatchedRoof.tscn")
const FIELD = preload("res://ProcField.tscn")

var chunk_id = null

# cheater tips https://godotengine.org/qa/24745/how-to-check-type-of-a-custom-class
func is_class(c): return c == "AutoChunk" or .is_class(c)
func get_class(): return "AutoChunk"

func _init(chunk_id: Vector2):
	self.chunk_id = chunk_id
	self.position = Vector2(
		chunk_id.x * Chunk.TILE_SIZE * Chunk.num_tiles_x,
		chunk_id.y * Chunk.TILE_SIZE * Chunk.num_tiles_y
	)
	add_child(FIELD.instance())
	
	print("auto chunk id  %s, pos %s" % [chunk_id,self.position])
	add_child(HOUSE.instance())

