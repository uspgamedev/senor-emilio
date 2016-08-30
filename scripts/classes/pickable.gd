
extends "res://scripts/classes/body.gd"

func _ready():
  print("box spawned")
  self.animation.play("down_idle")

func interact(body):
  var collide = self.get_layer_mask() & body.get_collision_mask()
  if collide != 0:
    body.grab(self)

func get_texture():
  return get_node("sprite").get_texture()
