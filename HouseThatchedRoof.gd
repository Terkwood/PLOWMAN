extends Node2D

var size = Vector2(196,196)

onready var chunk_id = Chunk.id(self)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	self.position = zone.position
	print("house parent is %s" % get_parent())
	print("my chunk id is %d" % chunk_id)
	$Torch2Body.set("chunk_id",Chunk.id($Torch2Body))
	print("torch chunk id is %s" % $Torch2Body.get("chunk_id"))
