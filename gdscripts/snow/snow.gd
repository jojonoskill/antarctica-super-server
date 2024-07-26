extends Sprite2D

@export var world_extents : Rect2 = Rect2(0.0, 0.0, 30.0, 30.0)
@onready var snow_field : CSGMesh3D = $"../SnowMesh"

@export var update_interval = 4
@export var snow_accumulation = 0.02
@export var img_w = 512
@export var img_h = 512

var time = 0 
var thread : Thread = Thread.new()
var radius = 2.7

func _ready():
	var img = Image.create(img_w, img_h, false, Image.FORMAT_RGB8)
	img.fill(Color.WHITE)
	texture.set_image(img)
	snow_field.material.set("shader_parameter/dynamic_snow_mask", texture)

func _process(delta):
	time += delta
	if time < update_interval:
		return

	start_accumulate()

func start_accumulate():
	if not thread.is_started():
		thread.start(_accumulate_thread)


func _accumulate_thread():
	var img = texture.get_image()

	for x in range(img.get_width()):
		for y in range(img.get_height()):
			var color = img.get_pixel(x, y)
			color.r = min(color.r + snow_accumulation, 1.0)
			color.g = min(color.g + snow_accumulation, 1.0)
			color.b = min(color.b + snow_accumulation, 1.0)
			img.set_pixel(x, y, color)

	texture.call_deferred("update", img)
	thread.call_deferred("wait_to_finish")
	time = 0
	
func _exit_tree():
	if thread:
		thread.wait_to_finish()
	
func is_point_on_canvas(x, y):
	return 0 <= x and x < img_w and 0 <= y and y < img_h
	
func draw_sprite_on_pos(x, y):
	var canvas_pos = transform_3d_pos_to_canvas(x, y)
	var img = texture.get_image()
	
	# Iterate over the area within the circle
	for dx in range(-radius, radius + 1):
		for dy in range(-radius, radius + 1):
			if dx * dx + dy * dy <= radius * radius:
				var canvas_x = canvas_pos.x + dx
				var canvas_y = canvas_pos.y + dy
				
				if not is_point_on_canvas(canvas_x, canvas_y):
					continue
					
				var dist = sqrt(dx * dx + dy * dy) / radius
				var color = Color.BLACK
				color.r = remap(dist, 0, radius, 0, 0.1) 
				img.set_pixel(canvas_x, canvas_y, color)
	
	texture.update(img)

func get_snow_amount_at_pos(x, y):
	var canvas_pos = transform_3d_pos_to_canvas(x, y)
	
	if not is_point_on_canvas(canvas_pos.x, canvas_pos.y):
		return 0
	
	return texture.get_image().get_pixel(canvas_pos.y, canvas_pos.x).r
	
func transform_3d_pos_to_canvas(x, y):
	var half_world_extents = world_extents.size * 0.5
	var pos = Vector2(x, y)
	
	pos += half_world_extents
	var brush_position = pos / world_extents.size
	
	return Vector2i(brush_position * Vector2(get_rect().size))
