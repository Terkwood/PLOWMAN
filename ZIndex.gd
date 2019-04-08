extends Node

const _RATE = 0.25
const _GR = 2000
const _M = _GR * _GR

func hack(s: Sprite):
	# This property will be added to the total, below.
	# Potentially useful if you need to put a cup of
	# coffee on the table.
	var az = s.get("actual_z_index")
	var actual_z_index = az if az else 0.0

	# these arithmetic gymnastics will ensure
	# that z-index is reasonable in negatively-numbered
	# position.y values
	var g = s.get_global_transform().get_origin().y + s.region_rect.size.y / 2 * s.scale.y
	var h = g * _RATE
	var i = int(h * _GR) if h >= 0 else int((_GR - abs(h)) * _GR)
	var j: float = (i % _M) / _GR + actual_z_index
	s.z_index = j
	s.z_as_relative = false
