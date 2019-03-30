extends KinematicBody2D


# matches the time for a single peck animation
const FREQ = 0.4

const MIN_SPEED = 150
const MAX_SPEED = 325
const MIN_STEPS = 3
const MAX_STEPS = 11

var dir = Vector2(1,0).normalized()
var steps = 0
var out_of_bounds = false

var timestamp = 0

func opposite(d: Vector2):
	return d * -1

const GO_RATE = 0.2

func random_steps():
	if randf() <= GO_RATE:
		return MIN_STEPS + randi()%(MAX_STEPS - MIN_STEPS)
	else:
		return 0

const POSSIBLE_DIRS = [
	Vector2(1,0),
	Vector2(-1,0),
	Vector2(0,1),
	Vector2(0,-1),
	Vector2(1,1),
	Vector2(-1,-1),
	Vector2(1,-1),
	Vector2(-1,1)
]

func walk_anim_for(direction: Vector2):
	if direction.x > 0 && direction.y < 0:
		return ["WalkRight", "WalkUp"][randi()%2]
	elif direction.x > 0 && direction.y > 0:
		return ["WalkRight", "WalkDown"][randi()%2]
	elif direction.x < 0 && direction.y < 0:
		return ["WalkLeft", "WalkUp"][randi()%2]
	elif direction.x < 0 && direction.y > 0:
		return ["WalkLeft", "WalkDown"][randi()%2]
	elif direction.x > 0:
		return "WalkRight"
	elif direction.x < 0:
		return "WalkLeft"
	elif direction.y > 0:
		return "WalkDown"
	elif direction.y < 0:
		return "WalkUp"
	return ""
	
func peck_anim_for(direction: Vector2):
	if direction.x > 0 && direction.y < 0:
		return ["PeckRight", "PeckUp"][randi()%2]
	elif direction.x > 0 && direction.y > 0:
		return ["PeckRight", "PeckDown"][randi()%2]
	elif direction.x < 0 && direction.y < 0:
		return ["PeckLeft", "PeckUp"][randi()%2]
	elif direction.x < 0 && direction.y > 0:
		return ["PeckLeft", "PeckDown"][randi()%2]
	elif direction.x > 0:
		return "PeckRight"
	elif direction.x < 0:
		return "PeckLeft"
	elif direction.y > 0:
		return "PeckDown"
	elif direction.y < 0:
		return "PeckUp"
	return ""

func random_dir():
	return POSSIBLE_DIRS[randi()%POSSIBLE_DIRS.size()].normalized()

func plan_next_move():
	steps = random_steps()
	dir = random_dir()

var pecking = false

func start_walk_anim():
	pecking = false
	if !$Sprite/AnimationPlayer.is_playing():
		$Sprite/AnimationPlayer.play(walk_anim_for(dir))
		
func move():
	if out_of_bounds:
		start_walk_anim()
		# don't change course until you're in bounds
		move_and_slide(dir * MAX_SPEED, Vector2())
	else:
		if steps > 0:
			start_walk_anim()
			move_and_slide(dir * rand_range(MIN_SPEED, MAX_SPEED), Vector2())
			steps -= 1
		else:
			if randi()%6 != 0:
				$Sprite/AnimationPlayer.stop(false)
				pecking = false
			elif !pecking:
				$Sprite/AnimationPlayer.play(peck_anim_for(dir))
				pecking = true
			else:
				$Sprite/AnimationPlayer.play()
			plan_next_move()

func i_am(body: KinematicBody2D):
	return body && body.get_instance_id() == get_instance_id()

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
	
func _ready():
	$Sprite/AnimationPlayer.assigned_animation = "WalkUp"
	ZIndex.hack(self.position.y, $Sprite, $Sprite)
	
func _on_Area2D_body_exited(body: KinematicBody2D):
	if i_am(body):
		dir = opposite(dir)
		$Sprite/AnimationPlayer.play(walk_anim_for(dir))
		steps = MAX_STEPS
		out_of_bounds = true

func _on_Area2D_body_entered(body):
	if i_am(body):
		out_of_bounds = false
		
