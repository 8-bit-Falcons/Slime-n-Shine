extends Node2D


@onready var weed_poster_sprite: Sprite2D = %WeedPosterSprite
@onready var censored_poster_sprite_2: Sprite2D = %CensoredPosterSprite


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.IS_PG:
		censored_poster_sprite_2.show()
	else:
		weed_poster_sprite.show()
