extends Node

var node_creation_parent = null

func instance_node(node, location, parent):
	var node_instance = node.instantiate()
	node_instance.global_position = location
	parent.add_child(node_instance)
	return node_instance
