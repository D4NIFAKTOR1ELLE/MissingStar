extends Node

var snowman = load("res://components/Snowman.tscn")
var star = load("res://components/Star.tscn")

var level1 = preload("res://levels/Level1.tscn")
var level2 = preload("res://levels/Level2.tscn")
var level3 = preload("res://levels/Level3.tscn")

func _ready() -> void:
	snowman = snowman.instantiate()
	star = star.instantiate()
