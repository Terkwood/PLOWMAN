extends Node2D

const HouseThatchedRoof = preload("res://HouseThatchedRoof.tscn")
const ProcField = preload("res://ProcField.tscn")
const AutoChicken = preload("res://AutoChicken.tscn")
const ProcFencedCow = preload("res://ProcFencedCow.tscn")
const ProcPlants = preload("res://ProcPlants.tscn")
const ProcPonds = preload("res://ProcPonds.tscn")

var chunk_id = null
onready var player = $"/root/ProcFarm".find_node("Player",true)

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
				get_parent().remove_child(get_parent().active_chunks[i])
				print("removed %s" % get_parent().active_chunks[i])
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
			if get_parent().packed_chunks.has(chunk_id + a) && !get_parent().packed_chunks[chunk_id + a].is_inside_tree():
				get_parent().add_child(get_parent().packed_chunks[chunk_id + a])
				print("loaded %s" % str(chunk_id + a))