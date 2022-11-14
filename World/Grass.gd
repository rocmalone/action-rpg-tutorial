extends Node2D


func create_grass_effect():
	# Store scene in a variable - not a node yet
	var GrassEffect = load("res://Effects/GrassEffect.tscn")

	# Create an instance of the GrassEffect - this is a node
	# We want to add the effect as a child of the world node
	var grassEffect = GrassEffect.instance()
	# Get the remote tree - then access the top level scene
	# i.e. World node
	var world = get_tree().current_scene
	world.add_child(grassEffect)
	# grassEffect.global_position = global_position of this grass node
	grassEffect.global_position = global_position
	
func _on_Hurtbox_area_entered(_area):
	
	create_grass_effect()
	# Add to queue of nodes which will be removed at the end of frame
	queue_free()
