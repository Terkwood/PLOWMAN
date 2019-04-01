extends Node

func _ready():
	InputMap.add_action("game_interact")
	var spacebar_event = InputEventKey.new()
	spacebar_event.scancode = OS.find_scancode_from_string("space")
	InputMap.action_add_event("game_interact", spacebar_event)

