@tool
extends GDAScreenBase

@onready var tburgbuz : ConfirmationDialog = $DeleteConfirmation
@onready var vhohkzas = $ScrollContainer/VBoxContainer
@onready var vowdgnyq = $"../ConversationManager"

@onready var hnkjtmru = $ScrollContainer/VBoxContainer/ErrorMessage
@onready var efubalqa = $ScrollContainer/VBoxContainer/ProcessMessage
@onready var nahavrzh = $ScrollContainer/VBoxContainer/AllConversationsHeader
@onready var pzzkgpai = $ScrollContainer/VBoxContainer/FavouritesHeader

var tofxdcui = preload("res://addons/gamedev_assistant/dock/scenes/ConversationSlot.tscn")

var astttizl
@onready var jtgfohqk = $".."

@onready var ajluegpv = $"../APIManager"

var mxlmuxwc : bool = false

func _ready ():
    vowdgnyq.wdquplpc.connect(prlptemq)
    ajluegpv.iwufumws.connect(nrmlheox)
    ajluegpv.xoyucvfi.connect(_on_delete_conversation_received)
    ajluegpv.miqfppqr.connect(nrmlheox)
    ajluegpv.sbufsbte.connect(nrmlheox)
    ajluegpv.lyxhzjdt.connect(_on_toggle_favorite_received)
    tburgbuz.confirmed.connect(lpwizcbi)
    
func _on_open ():
    fxayaylq()
    ajluegpv.yoleiwce()
    
                               
    
                                      
                                         
                                     

func fxayaylq ():
    for node in vhohkzas.get_children():
        if node is RichTextLabel:
            continue
        
        node.queue_free()
    
    hnkjtmru.visible = false
    efubalqa.visible = false

func prlptemq ():
    fxayaylq()
    
    var aachxopo = vowdgnyq.cgwggzwa()
    
    var ffoagmje : Array[Conversation] = []
    var nllxrven : Array[Conversation] = []
    
    for conv in aachxopo:
        if conv.favorited:
            ffoagmje.append(conv)
        else:
            nllxrven.append(conv)
    
    var cftunayb = 2
    vhohkzas.move_child(pzzkgpai, 1)
    
    for fav in ffoagmje:
        var wbgbdmvx = jshakajf(fav, jtgfohqk)
        vhohkzas.move_child(wbgbdmvx, cftunayb)
        cftunayb += 1
    
    vhohkzas.move_child(nahavrzh, cftunayb)
    cftunayb += 1
    
    for other in nllxrven:
        var wbgbdmvx = jshakajf(other, jtgfohqk)
        vhohkzas.move_child(wbgbdmvx, cftunayb)
        cftunayb += 1

func jshakajf (tmdlgksb, chvdedew) -> Control:
    var htnmxbti = tofxdcui.instantiate()
    vhohkzas.add_child(htnmxbti)
    htnmxbti.tphshgyb(tmdlgksb, chvdedew)
    return htnmxbti

                                            
                                        
func bxfrdsbu (jefubcnx):
    astttizl = jefubcnx
    tburgbuz.popup()

                                                        
func lpwizcbi():
    if astttizl == null or astttizl.get_conversation() == null:
        return
    
    var wkowfohz = astttizl.get_conversation()
    ajluegpv.cdojqhzs(wkowfohz.id)
    
    bmetlzxk("Deleting conversation...")

func _on_toggle_favorite_received ():
    ajluegpv.yoleiwce()

func _on_delete_conversation_received ():
    ajluegpv.yoleiwce()

func bmetlzxk (usiorqlw : String):
    return
    
    vhohkzas.move_child(efubalqa, 1)
    hnkjtmru.visible = false
    efubalqa.visible = true
    efubalqa.text = usiorqlw

func nrmlheox (fizfnfxg : String):
    vhohkzas.move_child(hnkjtmru, 0)
    efubalqa.visible = false
    hnkjtmru.visible = true
    hnkjtmru.text = fizfnfxg
