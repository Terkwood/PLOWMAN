extends Node2D

signal player_entered_chunk(chunk_id)

const HouseThatchedRoof = preload("res://HouseThatchedRoof.tscn")
const ProcField = preload("res://ProcField.tscn")
const AutoChicken = preload("res://AutoChicken.tscn")
const ProcFencedCow = preload("res://ProcFencedCow.tscn")
const ProcPlants = preload("res://ProcPlants.tscn")
const ProcPonds = preload("res://ProcPonds.tscn")

var chunk_id = null
onready var player = $"/root/ProcFarm".find_node("Player",true)

const NUM_CHICKENS = 4
const PLANT_SIZES = [
		Vector2(512,1024),
		Vector2(1024,512),
		Vector2(512,768),
		Vector2(768,256),
		Vector2(384,384)
	]
const NUM_PONDS = 2
const DRAW_HOUSE = true
const DRAW_FENCED_COW = true

var _storage_name = null
func storage_name():
	if !_storage_name:
		_storage_name = "chunk_%d_%s" % [OS.get_unix_time(), chunk_id]
	return _storage_name

func init(chunk_id: Vector2):
	self.chunk_id = chunk_id
	self.position = Vector2(
		chunk_id.x * Chunk.width(),
		chunk_id.y * Chunk.height()
	)

	var field = ProcField.instance()
	add_child(field)
	field.set_owner(self) # set owner so that resource saving works, https://godotengine.org/qa/903/how-to-save-a-scene-at-run-time

	# YOU MUST DRAW THE FENCED COW FIRST
	# Because ProcFencedCow does not respect other nodes' proc zones
	if DRAW_FENCED_COW:
		var fenced_cow = ProcFencedCow.instance()
		add_child(fenced_cow)
		fenced_cow.set_owner(self) # set owner so that resource saving works

	for i in range(NUM_CHICKENS):
		var cluck = AutoChicken.instance()
		add_child(cluck)
		cluck.set_owner(self) # set owner so that resource saving works

	for s in PLANT_SIZES:
		var plants = ProcPlants.instance()
		plants.size = s
		add_child(plants)
		plants.set_owner(self) # set owner so that resource saving works

	var ponds = ProcPonds.instance()
	ponds.num_ponds = NUM_PONDS
	add_child(ponds)
	ponds.set_owner(self) # set owner so that resource saving works

	if DRAW_HOUSE:
		var house = HouseThatchedRoof.instance()
		add_child(house)
		house.set_owner(self)# set owner so that resource saving works

	print("chunk _init complete: %s" % chunk_id)

var live = false
func _ready():
	connect("player_entered_chunk", get_parent(), "_on_player_entered_chunk")
	var area_2d = Area2D.new()
	area_2d.position.x += Chunk.width() / 2
	area_2d.position.y += Chunk.height() / 2
	var collision_area = CollisionShape2D.new()
	collision_area.shape = RectangleShape2D.new()
	collision_area.shape.extents = Chunk.size() / 2
	area_2d.connect("body_entered", self, "_on_Chunk_entered")
	add_child(area_2d)
	area_2d.set_owner(self) # set owner so that resource saving works, https://godotengine.org/qa/903/how-to-save-a-scene-at-run-time
	area_2d.add_child(collision_area)
	collision_area.set_owner(self) # set owner so that resource saving works
	live = true
	print("chunk _ready complete: %s" % chunk_id)

func _on_Chunk_entered(body: PhysicsBody2D):
	if live && body == player:
		emit_signal("player_entered_chunk", chunk_id)
