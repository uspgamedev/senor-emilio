
extends "res://scripts/classes/body.gd"

func _ready():
  print("box spawned")

func interact(body):
  var collide = self.get_layer_mask() & body.get_collision_mask() 
  if collide != 0:
    body.grab(self)
