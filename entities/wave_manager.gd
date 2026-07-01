class_name WaveManager
extends Node

var spawner: Node2D

@export var starting_wave: int = 1
@export var initial_spawn_interval: float = 5.0
@export var enemy_types: Array[PackedScene]
@export var spawnable_enemies: Array[PackedScene]

var current_wave: int = starting_wave
var enemies_to_spawn: int = 3
var spawn_timer: float
var current_spawn_interval: float = initial_spawn_interval
var _is_initializng_wave: bool = false
var enemies_to_kill: int = 0:
	set(value):
		enemies_to_kill = value
		if _is_initializng_wave:
			return

		if enemies_to_kill <= 0 and enemies_to_spawn <= 0:
			_complete_wave()

var spawnable_enemy_index: int = 0

signal wave_started(wave_number)
signal wave_completed(wave_number)

func _ready() -> void:
	spawner = get_parent() 
	Global.current_wave = current_wave
	_start_new_wave()

func _process(delta: float) -> void:
	spawn_timer -= delta
	if spawn_timer <= 0 and enemies_to_spawn > 0:
		_spawn_enemy()
		spawn_timer = current_spawn_interval

func _start_new_wave() -> void:
	_is_initializng_wave = true
	current_wave = Global.current_wave

	var wave_config = _get_wave_config()
	enemies_to_spawn = wave_config.enemy_count
	current_spawn_interval = wave_config.spawn_interval
	enemies_to_kill = enemies_to_spawn

	spawn_timer = 1

	_is_initializng_wave = false

	wave_started.emit(current_wave)

func _spawn_enemy() -> void:
	if spawner and spawner.has_method("spawn_enemy_at_random_terrain"):
		spawner.spawn_enemy_at_random_terrain(spawnable_enemies[randi_range(0, spawnable_enemies.size() - 1)])
	enemies_to_spawn -= 1

func _complete_wave() -> void:
	wave_completed.emit(current_wave)
	if current_wave % 3 == 0:
		get_tree().set_deferred("paused", true)
		get_parent().get_node("CanvasLayer/UpgradeScreen").visible = true
		if spawnable_enemy_index < enemy_types.size() - 1:
			spawnable_enemy_index += 1
			_add_spawnable_enemy(enemy_types[spawnable_enemy_index])

	Global.current_wave += 1
	_start_new_wave()

func _get_wave_config() -> Dictionary:
	return {
		"enemy_count": int(enemies_to_spawn + current_wave * 1.5),
		"spawn_interval": max(current_spawn_interval * (1.0 - (current_wave * 0.05)), 0.5)
	}

func _add_spawnable_enemy(enemy_scene: PackedScene) -> void:
	if enemy_scene not in spawnable_enemies:
		spawnable_enemies.append(enemy_scene)