extends EditorContextMenuPlugin

var nhwxocle: Control

func _init(pzebglfc: Control):                                                
    nhwxocle = pzebglfc

                                                                              
func rrxrftdm(adtcacve: PackedStringArray):
    add_context_menu_item("Add to Chat",teftwqow)
    add_context_menu_item("Explain Code",ositaono)

func ositaono(antzttkt: Node):
    if not (antzttkt is CodeEdit):
        return
    if antzttkt.has_selection():
        var lyviiljz = antzttkt.get_selected_text()
        if lyviiljz:         
                                                      
            var cgjrwgkq = Engine.get_singleton("EditorInterface")
            var ziycvbuv = cgjrwgkq.get_script_editor().get_current_script()
            if ziycvbuv:
                lyviiljz = "Explain this code from %s:\n\n%s" % [ziycvbuv.resource_path, lyviiljz]
            
                                                                                    
            if nhwxocle:  
                if not nhwxocle.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                    
                var bjiqrdtq : TextEdit = nhwxocle.get_node("Screen_Chat/Footer/PromptInput")         
                if bjiqrdtq:                                               
                    bjiqrdtq.insert_text_at_caret("\n" +lyviiljz)          
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

func teftwqow(wqcntjdd: Node):
    if not (wqcntjdd is CodeEdit):
        return
    if wqcntjdd.has_selection():
        var shrbmyfo = wqcntjdd.get_selected_text()
        if shrbmyfo:
                                                      
            var sftglmgi = Engine.get_singleton("EditorInterface")
            var niqxucai = sftglmgi.get_script_editor().get_current_script()
            if niqxucai:
                shrbmyfo = "Snippet from %s:\n%s" % [niqxucai.resource_path, shrbmyfo]
            
                                                                                    
            if nhwxocle:          
                if not nhwxocle.is_open_chat:
                    print("Please open the chat to use this command")
                    return
                                                                      
                var qyvvzqqa : TextEdit = nhwxocle.get_node("Screen_Chat/Footer/PromptInput")         
                if qyvvzqqa:                                               
                    qyvvzqqa.insert_text_at_caret("\n" +shrbmyfo)             
                else:                                                               
                    print("PromptInput node not found in the dock.")                
            else:                                                                   
                print("Dock reference is null.")          

            
            
            
