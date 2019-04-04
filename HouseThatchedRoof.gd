extends Node2D

var size = Vector2(128,128)

func _ready():
	var zone = ProcZoneRepo.assign_zone(size)
	self.position = zone.position