extends Node2D

const SceneStorage = preload("res://SceneStorage.gd")

const HouseThatchedRoof = preload("res://HouseThatchedRoof.tscn")
const ProcField = preload("res://ProcField.tscn")
const AutoChicken = preload("res://AutoChicken.tscn")
const ProcFencedCow = preload("res://ProcFencedCow.tscn")
const ProcPlants = preload("res://ProcPlants.tscn")
const ProcPonds = preload("res://ProcPonds.tscn")

var chunk_id = null
onready var player = $"/root/ProcFarm".find_node("Player",true)

onready var storage = SceneStorage.new()
var storage_name = null

func _init(chunk_id: Vector2):
	self.chunk_id = chunk_id
	self.position = Vector2(
		chunk_id.x * Chunk.width(),
		chunk_id.y * Chunk.height()
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
	
	if storage_name == null:
		storage_name = "chunk_%d_%s" % [OS.get_unix_time(), chunk_id]

var live = false
func _ready():
	var area_2d = Area2D.new()
	area_2d.position.x += Chunk.width() / 2
	area_2d.position.y += Chunk.height() / 2
	var collision_area = CollisionShape2D.new()
	collision_area.shape = RectangleShape2D.new()
	collision_area.shape.extents = Chunk.size() / 2
	area_2d.connect("body_entered", self, "_on_Chunk_entered")
	add_child(area_2d)
	area_2d.add_child(collision_area)
	live = true

func _on_Chunk_entered(body: PhysicsBody2D):
	if live && body == player:
		print("player entered chunk %s" % chunk_id)
		for i in get_parent().active_chunks:
			if (i.x < chunk_id.x - 1 || i.x > chunk_id.x + 1) && (
				i.y < chunk_id.y - 1 || i.y > chunk_id.y + 1
			):
				print("chunk %s to save" % i)
				var chunk = get_parent().active_chunks[i]
				get_parent().remove_child(chunk)
				var file = storage.save_scene(chunk, chunk.storage_name)
				get_parent().active_chunks.erase(i)
				get_parent().stored_chunks[i] = file
				print("saved to disk: %s" % file)
		var adjacents = [
			Vector2(1,0),
			Vector2(-1,0),
			Vector2(0,1),
			Vector2(0,-1),
			Vector2(-1,-1),
			Vector2(-1,1),
			Vector2(1,-1),
			Vector2(1,1)
		]

		for a in adjacents:
			if get_parent().stored_chunks.has(chunk_id + a):
				var file = get_parent().stored_chunks[chunk_id + a]
				var chunk = storage.load_scene(file, get_parent())
				get_parent().stored_chunks.erase(file)
				get_parent().active_chunks[chunk_id + a] = chunk
				print("loaded %s" % str(chunk_id + a))