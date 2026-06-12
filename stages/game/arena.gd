extends Node2D


func _ready() -> void:
	NodeSpawner.node_creation_parent = self

func _exit_tree() -> void:
	NodeSpawner.node_creation_parent = null