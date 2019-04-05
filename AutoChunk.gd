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
	
	add_child(HouseThatchedRoof.instance())

	for i in range(4):
		var cluck = AutoChicken.instance()
		if i == 3:
			cluck.zone_size = Vector2(512,512)
		add_child(cluck)
	
	add_child(ProcFencedCow.instance())

	var plant_sizes = [
		Vector2(512,1024),
		Vector2(1024,512),
		Vector2(768,768),
		Vector2(768,768),
		Vector2(768,768)
	]
	
	for s in plant_sizes:
		var plants = ProcPlants.instance()
		plants.size = s
		add_child(plants)
	
	var ponds = ProcPonds.instance()
	ponds.num_ponds = 2
	add_child(ponds)
