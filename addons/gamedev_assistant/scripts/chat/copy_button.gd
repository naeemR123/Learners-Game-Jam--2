                                                       
@tool
extends CodeEdit

@onready var utiwzgjo: Button = $CopyButton

func _ready():
    utiwzgjo.connect("pressed",rsajguez)

func rsajguez():
    var roemybea = text
    if roemybea:
        DisplayServer.clipboard_set(roemybea)
