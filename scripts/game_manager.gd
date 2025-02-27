extends Node2D

var enemy_scene = preload("res://scenes/enemy.tscn")
var spawn_points = []
var wave_size = 5
var enemies_to_spawn = 0
var wave_delay = 5.0
var enemy_spawn_delay = 1.0

func _ready():
	# Get spawn points - assumes you have Node2D children named SpawnPoint1, SpawnPoint2, etc.
	for child in get_children():
		if "SpawnPoint" in child.name:
			spawn_points.append(child)
	
	if spawn_points.size() == 0:
		print("Error: No spawn points found!")
	
	# Start first wave
	start_wave()

func start_wave():
	enemies_to_spawn = wave_size
	$EnemySpawnTimer.wait_time = enemy_spawn_delay
	$EnemySpawnTimer.start()

func spawn_enemy():
	if enemies_to_spawn > 0:
		var enemy = enemy_scene.instantiate()
		
		# Choose a random spawn point
		var spawn_point = spawn_points[randi() % spawn_points.size()]
		enemy.global_position = spawn_point.global_position
		
		add_child(enemy)
		enemies_to_spawn -= 1
	
	# If all enemies are spawned, prepare for next wave
	if enemies_to_spawn <= 0:
		$EnemySpawnTimer.stop()
		$WaveDelayTimer.wait_time = wave_delay
		$WaveDelayTimer.start()

func _on_enemy_spawn_timer_timeout():
	spawn_enemy()

func _on_wave_delay_timer_timeout():
	# Increase difficulty for next wave
	wave_size += 2
	start_wave()
