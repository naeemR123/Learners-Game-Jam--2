@tool
class_name Conversation
extends Node

                                                                             

var messages : Array[Message] = []
var title : String
var id : int = -1
var favorited : bool = false
var has_been_fetched : bool = false

class Message:
    var role : String
    var content : String

                                           
                                                                    
func luqkpwfp () -> String:
    if len(title) > 0:
        return title
    
    if len(messages) == 0:
        return "Empty chat..."
    
    return messages[0].content

func utosdrou (cjigcidv : String):
    var dkciogkx = Message.new()
    dkciogkx.role = "user"
    dkciogkx.content = cjigcidv
    messages.append(dkciogkx)

func taflbyvn (ccetqivz : String):
    var rnasvlia = Message.new()
    rnasvlia.role = "assistant"
    rnasvlia.content = ccetqivz
    messages.append(rnasvlia)
