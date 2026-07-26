extends Control

# 在这里修改你的三句话
var dialogue_lines = [
    "Everyone says there’s a perfect jar inside the bell tower.",
    "Sometimes I feel like I have everything I need.",
    "But as for today...",
    "I think what I'm really missing is the perfect jar."
]

# 当前显示到第几句话（从0开始）
var current_line_index = 0

# 引用场景中的节点
@onready var dialogue_label = $DialogueLabel

# 在游戏设置里，把要切换的主游戏场景路径填在这里
@export var game_scene_path: String = "res://path/to/your/game_scene.tscn"

func _ready():
    # 游戏一开始，显示第一句话
    update_dialogue()

func _input(event):
    # 检测是否有任意按键按下 (鼠标点击或键盘按键)
    # is_action_just_pressed 配合 ui_accept 可以检测空格/回车/鼠标点击，但不是“任意键”
    # 下面的方法可以检测到任意键盘按键或鼠标点击
    if event is InputEventKey or event is InputEventMouseButton:
        # 确保是“按下”事件，而不是“释放”，避免一次操作触发多次
        if event.is_pressed():
            # 处理“按任意键”的逻辑
            handle_any_key_press()

func handle_any_key_press():
    # 检查是否还有下一句话
    if current_line_index < dialogue_lines.size() - 1:
        # 还有下一句，则索引加1，更新文本
        current_line_index += 1
        update_dialogue()
    else:
        # 已经是最后一句了，开始游戏！
        start_game()

func update_dialogue():
    # 更新 RichTextLabel 的文本
    dialogue_label.text = dialogue_lines[current_line_index]
    # 进阶功能：如果你想让文字有“打字机”效果，可以在这里添加代码
    # 例如：dialogue_label.visible_characters = 0
    # 然后使用 Tween 或 Timer 逐渐增加 visible_characters 的值[reference:2]

func start_game():
    # 切换到主游戏场景[reference:3][reference:4]
    # 根据你的 Godot 版本选择合适的方法
    get_tree().change_scene_to_file(game_scene_path)
    # 或者，如果 game_scene_path 是 PackedScene 类型，可以用 change_scene_to_packed