@tool
extends EditorPlugin

var icon = preload("res://addons/health_bar_2d/icon.png")
var health_bar_2d = preload("res://addons/health_bar_2d/health_bar_2d.gd")


func _enter_tree():
	add_custom_type("HealthBar2D", "TextureProgressBar", health_bar_2d, icon)


func _exit_tree():
	remove_custom_type("HealthBar2D")
