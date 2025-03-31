extends VBoxContainer

var icons_directory = "res://Sprites/player_sprites/guns/icons/"
@onready var gunIcon: TextureRect = $icon
@onready var gunName: Label = $name

func _ready() -> void:
    Global.playerInstance.switch_weapon_icon.connect(switch_handler)

func switch_handler(new_gun: String):
    gunName.text = new_gun
    gunIcon.texture = load(icons_directory + new_gun + ".png")