extends StaticBody2D

export(NodePath) var first_message = null

onready var hud = get_node("/root/main/HUD")

func interact(body):
	hud.init_dialog(get_node(first_message))