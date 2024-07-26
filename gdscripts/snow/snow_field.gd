extends SubViewport

@export var world_extents : Rect2 = Rect2(0.0, 0.0, 30.0, 30.0)

func get_snow_amount_at_pos(x, y):
	
	
	var canvas_pos = transform_3d_pos_to_canvas(x, y)
	return get_texture().get_image().get_pixel(canvas_pos.y, canvas_pos.x).r;
	
func transform_3d_pos_to_canvas(x, y):
	var half_world_extents = world_extents.size * 0.5
	var pos = Vector2(x, y)
	
	pos += half_world_extents
	var brush_position = pos / world_extents.size	
	
	return brush_position * Vector2(get_parent().size)
