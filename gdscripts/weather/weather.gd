extends WorldEnvironment

@onready var snow_particles : GPUParticles3D = $GPUParticles3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_turn_on_snow_toggled(toggled_on):
	if toggled_on:
		snow_particles.hide()
	else:
		snow_particles.show()
