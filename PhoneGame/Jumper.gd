extends Area2D

signal captured

onready var trail = $Trail/Points

var velocity = Vector2(100, 0)
var jump_speed = 1000
var target = null
var trail_length = 25

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.is_pressed():
		jump()
		
func jump():
	target.implode()
	# detach from orbit_position Position2D node
	target = null
	#transform.x is the direction we're pointing in 
	velocity = transform.x * jump_speed

# This is called when the player connects to a circle
# It sets the target = to the circle's Area2D
# It removes velocity so the player can start rotating
# It emits a signal saying it's captured/connected and passes what it connected to
func _on_Jumper_area_entered(area):
	target = area
	# This gets the vector between your position and the target position
	# Then it gets the ANGLE of this vector. Since a vector is simply a magnitude + direction (angle)
	# And it sets the Pivot angle to this angle so that the player always snaps to this place
	target.get_node("Pivot").rotation = (position - target.position).angle()
	velocity = Vector2.ZERO
	emit_signal("captured", area)
	
func _physics_process(delta):
	if trail.points.size() > trail_length:
		trail.remove_point(0)
	trail.add_point(position)
	# If a target exists then follow the transform of orbit_position
	# orbit_position here reprsents a path node
	# transform is what scales, rotates
	# So setting the transform to be equal means if the orbit_position node rotates then this node rotates
	# global_transform is in global space (total screen space not relative to parent/child)
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
