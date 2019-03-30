extends Node

func hack(y, n: Node2D, s: Sprite):
	var g = n.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	n.z_index=g
