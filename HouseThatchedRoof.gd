extends Node2D

var size = Vector2(196,196)

onready var chunk_id = Chunk.id(self)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	self.position = zone.position
	print("house chunk id %s" % chunk_id)
