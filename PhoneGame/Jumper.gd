extends Area2D

var velocity = Vector2(100, 0)
var jump_speed = 1000
var target = null

func _unhandled_input(event):
	if target and event is InputEventScreenTouch and event.is_pressed():
		jump()
		
func jump():
	# detach from orbit_position Position2D node
	target = null
	#transform.x is the direction we're pointing in 
	velocity = transform.x * jump_speed


func _on_Jumper_area_entered(area):
	target = area
	velocity = Vector2.ZERO
	
func _physics_process(delta):
	# If a target exists then follow the transform of orbit_position
	# orbit_position here reprsents a path node
	# transform is what scales, rotates
	# So setting the transform to be equal means if the orbit_position node rotates then this node rotates
	# global_transform is in global space (total screen space not relative to parent/child)
	if target:
		transform = target.orbit_position.global_transform
	else:
		position += velocity * delta
