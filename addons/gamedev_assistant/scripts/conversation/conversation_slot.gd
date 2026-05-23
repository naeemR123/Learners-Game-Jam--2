@tool
extends Button

@onready var lrsseabd : Label = $PromptLabel
@onready var frfyrmcl : TextureButton = $FavouriteButton
@onready var ktnddrwh : Button = $DeleteButton

@export var non_favourite_color : Color
@export var favourite_color : Color

var stwcoxud : Conversation
var mlysaegt

func _ready():
    frfyrmcl.modulate = non_favourite_color
    
                                
    pressed.connect(vtqrcjqg)
    ktnddrwh.pressed.connect(ossdmwxc)
    frfyrmcl.pressed.connect(qirqijvf)

                                                 
func tphshgyb (jsljvpzp : Conversation, aypbxgzo):
    stwcoxud = jsljvpzp
    mlysaegt = aypbxgzo
    lrsseabd.text = stwcoxud.luqkpwfp().replace("\n", "")                    
    ffoazhod()

                                                
func vtqrcjqg():
    mlysaegt.hvmjihvs(stwcoxud)

                              
                                    
func ossdmwxc():
    $"../../..".bxfrdsbu(self)

func qirqijvf():
                                                          
    var agtyuxun = mlysaegt.qqkfjbkp()
    agtyuxun.rzdzryda(stwcoxud, not stwcoxud.favorited)
    ffoazhod()

func ffoazhod ():
    if stwcoxud.favorited:
        frfyrmcl.modulate = favourite_color
    else:
        frfyrmcl.modulate = non_favourite_color

func get_conversation():
    return stwcoxud
