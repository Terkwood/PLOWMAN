extends Node2D

const HouseThatchedRoof = preload("res://HouseThatchedRoof.tscn")
const ProcField = preload("res://ProcField.tscn")
const AutoChicken = preload("res://AutoChicken.tscn")
const ProcFencedCow = preload("res://ProcFencedCow.tscn")
const ProcPlants = preload("res://ProcPlants.tscn")
const ProcPonds = preload("res://ProcPonds.tscn")

var chunk_id = null

func _init(chunk_id: Vector2):
	self.chunk_id = chunk_id
	self.position = Vector2(
		chunk_id.x * Chunk.TILE_SIZE * Chunk.num_tiles_x,
		chunk_id.y * Chunk.TILE_SIZE * Chunk.num_tiles_y
	)
	add_child(ProcField.instance())
	
	print("auto chunk id  %s, pos %s" % [chunk_id,self.position])
	add_child(HouseThatchedRoof.instance())

	for i in range(4):
		var cluck = AutoChicken.instance()
		cluck.zone_size = Vector2(32,32)
		add_child(cluck)
	
	add_child(ProcFencedCow.instance())

	for i in range(3):
		add_child(ProcPlants.instance())
	
	add_child(ProcPonds.instance())
