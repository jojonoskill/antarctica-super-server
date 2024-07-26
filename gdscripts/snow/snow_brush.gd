extends Sprite2D

@onready var viewport : SubViewport = get_parent()

var player : CharacterBody3D

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	
func _ready():
	if not is_multiplayer_authority(): return
	
func _process(delta):
	if not is_multiplayer_authority(): return
	
	if not player:
		queue_free()
		return
	
	position = viewport.transform_3d_pos_to_canvas(player.position.x, player.position.z)
