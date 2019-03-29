extends KinematicBody2D

enum Direction { N, NE, E, SE, S, SW, W, NW }
enum Movement { STOP, GO }

var dir = Direction.E
var mv = Movement.STOP

var timestamp = 0
const FREQ = 0.5

func opposite(d):
	return Direction.keys()[Direction.values()[(d + 4)%8]]

func _ready():
	move_and_collide(Vector2(300,0))

func move():
	print("MOVE BIRD")
	
func _physics_process(delta):
	print("timestamp "+str(timestamp))
	timestamp = timestamp + delta
	if timestamp > FREQ:
		move()
		timestamp = 0
		

func _on_Area2D_body_exited(body: KinematicBody2D):
	if body.get_instance_id() == get_instance_id():
		print("cluck "+str(get_instance_id()))
		dir = opposite(dir)
		print("new dir " + str(dir))