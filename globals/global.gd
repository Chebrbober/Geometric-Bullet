extends Node

@export var score: int = 0
var node_creation_parent = null
var player = null
var current_wave: int = 1

signal score_changed(new_score)
signal wave_changed(new_wave)

func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	node_instance.global_position = location
	parent.add_child(node_instance)
	return node_instance
