extends TileMap

func _physics_process(delta):
	if(Input.is_action_just_pressed("mb_left")):
		var tile : Vector2 = world_to_map(get_global_mouse_position())
		set_cellv(tile,-1)

	if(Input.is_action_just_pressed("mb_right")):
		var tile : Vector2 = world_to_map(get_global_mouse_position())
		set_cellv(tile,0)
