
extends "res://scripts/classes/body.gd"

func _ready():
  print("box spawned")

func interact(body):
  if self.get_layer_mask() == body.get_layer_mask():
    body.grab(self)
