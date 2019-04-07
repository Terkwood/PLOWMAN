extends Node2D

var size = Vector2(196,196)

onready var chunk_id = Chunk.id(self)

func manifest():
	return StorageManifest.position_manifest(self)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size, chunk_id)
	self.position = zone.position
