
extends "res://scripts/classes/body.gd"

func _ready():
  print("box spawned")

func interact(body):
  body.grab(self)
