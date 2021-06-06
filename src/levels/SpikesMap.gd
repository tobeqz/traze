extends TileMap

func _death_entered(body: Node):
	if body.name == 'Player':
		body.die()
	pass # Replace with function body.
