@tool
extends Node

                                        
                             
                               

signal jtsehhxe (conversation : Conversation)

                                                                    
signal wdquplpc
signal uulcclje

var kklrdtcx : Array[Conversation]
var omngbfto : Conversation

@onready var ancneyyi = $"../APIManager"
@onready var ayohncak = $".."
@onready var jfkprrea = $"../Screen_Conversations"

func _ready ():
    ancneyyi.eajsjrje.connect(pxvjteue)
    ancneyyi.hmjvhfxe.connect(_on_send_message_received)
    
    ancneyyi.xcxxpngk.connect(enrnjxoy)
    ancneyyi.czvetcnr.connect(naykgvgu)

func xxitjzwl () -> Conversation:
    fipugthy()                                            

    var pcrfwnid = Conversation.new()
    pcrfwnid.id = -1                                       
    kklrdtcx.append(pcrfwnid)
    omngbfto = pcrfwnid
    return pcrfwnid

func fipugthy ():
    if omngbfto != null:
        if omngbfto.id == -1:                                    
            kklrdtcx.erase(omngbfto)
    
    omngbfto = null

func hfrrozwf (vosudctv : Conversation):
    omngbfto = vosudctv
    uulcclje.emit()

                                                                    
                                                                              
func enrnjxoy (atzuvahi):
    kklrdtcx.clear()
    
    for conv_data in atzuvahi:
        var mdrunebz = Conversation.new()
        mdrunebz.id = int(conv_data["id"])
        mdrunebz.title = conv_data["title"]
        mdrunebz.favorited = conv_data["isFavorite"]
        kklrdtcx.append(mdrunebz)
    
    wdquplpc.emit()

                                   
func pxvjteue(sdkbbwrp: String):
    if omngbfto == null:
                                           
        xxitjzwl()
    
                                                     
                                                    
                           
       
    omngbfto.utosdrou(sdkbbwrp)

func _on_send_message_received(hekwwqkh: String, kplobcqt: int):
    print("Received assistant message: ", {
        "conversation_id": kplobcqt,
        "current_conv_id": omngbfto.id if omngbfto else "none",
        "content": hekwwqkh
    })
    if omngbfto:
        if omngbfto.id == -1:
                                                                    
            omngbfto.id = kplobcqt
        omngbfto.taflbyvn(hekwwqkh)

                                                                                      
                                                                     
func zjuxgbvd (nwzzuzrg : int):
    ancneyyi.get_conversation(nwzzuzrg)

                                                            
                                                 
func naykgvgu (bhvhavew):
    var jaqkklqs : Conversation
    var xorqqzst = bhvhavew["id"]
    xorqqzst = int(xorqqzst)
    
                                                
    for c in kklrdtcx:
        if c.id == xorqqzst:
            jaqkklqs = c
            break
    
                                              
    if jaqkklqs == null:
        jaqkklqs = Conversation.new()
        jaqkklqs.id = xorqqzst
        jaqkklqs.title = bhvhavew["title"]
        kklrdtcx.append(jaqkklqs)
    
    jaqkklqs.messages.clear()
    
                                                    
    for message in bhvhavew["messages"]:
        if message["role"] == "user":
            jaqkklqs.utosdrou(message["content"])
        elif message["role"] == "assistant":
            jaqkklqs.taflbyvn(message["content"])
    
    jaqkklqs.has_been_fetched = true
    hfrrozwf(jaqkklqs)

func rzdzryda (cmpguxyp : Conversation, uidyhldq : bool):
    ancneyyi.pvxvfono(cmpguxyp.id)
    
    if uidyhldq:
        jfkprrea.bmetlzxk("Adding favorite...")
    else:
        jfkprrea.bmetlzxk("Removing favorite...")

func cgwggzwa():
    return kklrdtcx
    
func uziqrmqg():
    return omngbfto
    
func pdcvcxsj(aptacrpe: int):
    omngbfto.id = aptacrpe
