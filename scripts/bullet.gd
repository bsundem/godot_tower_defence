extends Area2D

var speed = 300
var damage = 5
var target = null
var max_lifetime = 5.0

func _ready():
	# Set a maximum lifetime to avoid bullets flying forever
	$LifetimeTimer.wait_time = max_lifetime
	$LifetimeTimer.start()

func _process(delta):
	if target and is_instance_valid(target):
		# Move toward the target
		var direction = (target.global_position - global_position).normalized()
		global_position += direction * speed * delta
	else:
		# Target is no longer valid
		queue_free()

func _on_body_entered(body):
	if body is CharacterBody2D and body.is_in_group("enemies"):
		body.take_damage(damage)
		queue_free()

func _on_lifetime_timer_timeout():
	queue_free()
