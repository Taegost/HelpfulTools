# This goes with the matching .tscn file.
#
# SUMMARY
# This script will set the maximum boundaries for the camera based on how many tiles there are in the scene.
# This is very useful for 2d sprite-based game scenes whose boundaries stay within the scene. 
extends Camera2D

@export var tilemap: TileMap

func _ready():
	var map_rect = tilemap.get_used_rect()
	var tile_size = tilemap.cell_quadrant_size
	var world_size_in_pixels = map_rect.size * tile_size
	limit_top = 0
	limit_left = 0
	limit_right = world_size_in_pixels.x
	limit_bottom = world_size_in_pixels.y
