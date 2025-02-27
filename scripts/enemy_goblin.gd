extends CharacterBody2D

var speed = 100
var health = 10
var damage = 10
var tower_node = null

func _ready():
	add_to_group("enemies")
	
	# Find the tower node
	tower_node = get_tree().get_first_node_in_group("tower")
	if not tower_node:
		print("Error: Tower not found!")

func _physics_process(delta):
	if tower_node:
		# Simple AI: move directly toward the tower
		var direction = (tower_node.global_position - global_position).normalized()
		velocity = direction * speed
		move_and_slide()

func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()

func _on_hit_box_area_entered(area):
	if area.is_in_group("tower_hitbox"):
		# Enemy reached the tower, deal damage
		tower_node.take_damage(damage)
		queue_free()
