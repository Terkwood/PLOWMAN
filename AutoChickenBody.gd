extends KinematicBody2D

enum Direction { N, NE, E, SE, S, SW, W, NW }
enum Movement { STOP, GO }

const FREQ = 0.5
const MIN_SPEED = 50
const MAX_SPEED = 250

var dir = Direction.E
var mv = Movement.STOP
var out_of_bounds = false

var timestamp = 0

func dir_vector(d):
	var r = Vector2()
	match d:
		Direction.N:
			r = Vector2(0,-1)
		Direction.S:
			r = Vector2(0,1)
		Direction.E:
			r = Vector2(1,0)
		Direction.W:
			r = Vector2(-1,0)
		Direction.NE:
			r = Vector2(1,-1)
		Direction.SE:
			r = Vector2(1,1)
		Direction.SW:
			r = Vector2(-1,1)
		Direction.NW:
			r = Vector2(-1,-1)
	return r.normalized()

func opposite(d):
	return Direction.keys()[Direction.values()[(d + 4)%8]]

func _ready():
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	move_and_slide(Vector2(300,0), Vector2())

func move():
	print("chicken move")
	if out_of_bounds:
		# don't change course until you're in bounds
		move_and_slide(dir_vector(dir) * MAX_SPEED, Vector2())
	else:
		move_and_slide(dir_vector(dir) * rand_range(MIN_SPEED, MAX_SPEED), Vector2())
	
func _physics_process(delta):
	timestamp = timestamp + delta
	if timestamp > FREQ:
		move()
		timestamp = 0

var last_position_y = self.position.y
func _process(_delta):
	if self.position.y != last_position_y:
		last_position_y = self.position.y
		ZIndex.hack(self.position.y, $Sprite, $Sprite)

func i_am(body: KinematicBody2D):
	return body && body.get_instance_id() == get_instance_id()
	
func _on_Area2D_body_exited(body: KinematicBody2D):
	if i_am(body):
		dir = opposite(dir)
		mv = Movement.GO
		out_of_bounds = true
		print("new dir " + str(dir))

func _on_Area2D_body_entered(body):
	if i_am(body):
		out_of_bounds = false
		
