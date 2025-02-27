extends Node2D

var health = 100
var reload_time = 0.5
var bullet_speed = 300
var can_shoot = true
var bullet_scene = preload("res://scenes/bullet.tscn")

func _ready():
	$ReloadTimer.wait_time = reload_time

func _process(delta):
	if health <= 0:
		game_over()
	
	# Auto-targeting of closest enemy
	var enemies = get_tree().get_nodes_in_group("enemies")
	if enemies.size() > 0 and can_shoot:
		var closest_enemy = find_closest_enemy(enemies)
		if closest_enemy:
			shoot_at(closest_enemy)

func find_closest_enemy(enemies):
	var closest_distance = INF
	var closest_enemy = null
	
	for enemy in enemies:
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	
	return closest_enemy

func shoot_at(enemy):
	can_shoot = false
	$ReloadTimer.start()
	
	# Instance bullet
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.target = enemy
	bullet.speed = bullet_speed
	get_parent().add_child(bullet)

func take_damage(amount):
	health -= amount
	# You could add visual feedback here

func game_over():
	# Handle game over state
	get_tree().call_group("enemies", "queue_free")
	print("Game Over!")
	# Could show a game over screen here

func _on_reload_timer_timeout():
	can_shoot = true
