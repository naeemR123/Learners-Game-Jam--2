                                                        
@tool                                                                                         
extends TextEdit                                                                              
                                                                                                
signal gzopntpm    

const eduobxoy = 50000                                                                    
                                                                                                
var bsqyhfhd : bool = false                                                              
var ptmfbefx : Control                                                                          
                         
                                                                                    
func _ready():                                                                                
                                                                                              
    ptmfbefx = get_parent()       
    
                       
    tooltip_text = "Type your message here (Enter to send, Shift+Enter for new line)\nTo include scripts you need to either paste the code here, use @OpenScripts,\n or select the code in the editor + right click for contextual menu \"Add to Chat\"\nThe file tree and open scene nodes are automatically included"
                                                                                                
                                                                                              
    connect("focus_entered", Callable(self, "mhytyaxj"))                
    connect("text_changed", Callable(self, "nivxaqht")) 
    connect("focus_exited", Callable(self, "lfvtknbu"))            
    
    var deaylytm = get_parent().get_parent()                                                    
    if deaylytm.has_signal("ynsjnasz"):  
        deaylytm.connect("ynsjnasz", Callable(self, "lrkbooxy"))  
                
                                                                                                
func _input(bndnycdk):
    if has_focus():
        if bndnycdk is InputEventKey and bndnycdk.is_pressed():
            if bndnycdk.keycode == KEY_ENTER:
                if bndnycdk.shift_pressed:
                    insert_text_at_caret("\n")
                                                                
                    bvvlhmun(1)
                    get_viewport().set_input_as_handled()
                else:                                                                         
                                                                             
                    var uzybtfds = get_parent().get_node("SendPromptButton")  
                    if uzybtfds and uzybtfds.disabled == false:  
                        gzopntpm.emit()                                                       
                        get_viewport().set_input_as_handled()
                        lrkbooxy()    

func bvvlhmun(dkyjqswi: int = 0):
    var qculybqc = get_theme_font("font")
    var tzfunydn = get_theme_font_size("font_size")
    var nfuubevc = qculybqc.get_char_size('W'.unicode_at(0), tzfunydn).x * 0.6
    var zoyohhli = int(size.x / nfuubevc)
    var hoznrbxa = qculybqc.get_height(tzfunydn) + 10
    var lsyymeit = hoznrbxa * 10        
    var cwugdfjc = hoznrbxa*2
    var mttnqbfb = -cwugdfjc*2
    
    var dwxpljdb = 0
    for i in get_line_count():
        var muldegdq = get_line(i)
        var nbslspqk = muldegdq.length()
        var fgxzbpzs = ceili(float(nbslspqk) / float(zoyohhli))
        dwxpljdb += max(fgxzbpzs, 1)                         
        
                                             
    dwxpljdb += dkyjqswi
    
    var qitbvvhx = dwxpljdb * hoznrbxa + cwugdfjc
    qitbvvhx = clamp(qitbvvhx, cwugdfjc, lsyymeit)
    ptmfbefx.offset_top = -qitbvvhx


func niiksseo():
    bvvlhmun()                                                                        
                                                                                                
func mhytyaxj():                                                        
    niiksseo()                                                                     
                                                                                                
func nivxaqht():                                                         
    niiksseo()
    
                                                                                     
    if text.length() > eduobxoy:                                               
        text = text.substr(0, eduobxoy)                                        
        set_caret_column(eduobxoy)                                                                                                        
                                                                                                
func lrkbooxy():                                                                    
    niiksseo()

func lfvtknbu(): 
    if text.length() == 0:                                                        
        lrkbooxy()
