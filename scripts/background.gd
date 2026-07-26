extends CanvasLayer

@export var parallax_amount: float = 0.2

var backgrounds: Array[TextureRect]

func _ready() -> void:
  for i: int in get_child_count():
    var c: Node = get_child(i)
    if c is TextureRect:
      backgrounds.append(c)

func _process(_delta: float) -> void:
  var x: float = get_viewport().get_camera_2d().get_screen_center_position().x
  for i: int in backgrounds.size():
    var m: ShaderMaterial = backgrounds[i].material as ShaderMaterial
    m.set_shader_parameter("scroll", Vector2(
      x * parallax_amount * (i+1) / backgrounds[i].texture.get_width(),
      0.0
    ))
