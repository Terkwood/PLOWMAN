extends Node

export var bitmask = 0

enum Tile { Ground, Water }
enum Dir { N, E, S, W }

func suggest_tile(dir):
	match dir:
		Dir.N:
			return null
