                                                                    
@tool
extends TextEdit

@export var max_length = 1000                                        
const krouhxqn = "gamedev_assistant/custom_instructions"

func _ready():
    text_changed.connect(zfjxbxxs)

func zfjxbxxs():
                             
    if text.length() > max_length:
        var khfyjlxw = get_caret_column()
        text = text.substr(0, max_length)
        set_caret_column(min(khfyjlxw, max_length))
    
                        
    var pounuwii = EditorInterface.get_editor_settings()
    pounuwii.set_setting(krouhxqn, text)
