
extends SamplePlayer

const GRAB_SFX = preload("res://assets/sfx/Grab.smp")
const DROP_SFX = preload("res://assets/sfx/Drop.smp")

onready var samplib = get_sample_library()

func _ready():
	samplib.add_sample("grab", GRAB_SFX)
	samplib.add_sample("drop", DROP_SFX)
