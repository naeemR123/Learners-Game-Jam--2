                                         
@tool
extends Control

@onready var vtxkafri = $Screen_Conversations
@onready var wnggyvne = $Screen_Chat
@onready var pfpwgqhw = $Screen_Settings

@onready var kiodhthh = $Header/HBoxContainer/ConversationsButton
@onready var idgfbfgh = $Header/ChatButton
@onready var gygqmkqc = $Header/HBoxContainer/SettingsButton
@onready var ytiqnbbm = $Header/ScreenText

@onready var ivddsahv = $ConversationManager
@onready var jloldkky = $APIManager

                                          
var harglvrj : bool = false

                                                    
var yjksmhvt : bool = false

func _ready():
    yuvrqhzh(false)
    
                                       
    jloldkky.apwgvoge.connect(lupcgeuj)
    jloldkky.agqfwpxl.connect(lupcgeuj)
    
                                   
    idgfbfgh.pressed.connect(jnodkrnq)
    gygqmkqc.pressed.connect(kjezrtol)
    kiodhthh.pressed.connect(sqgwcqfv)
    
    var ganpidnd = EditorInterface.get_editor_settings()
    
                                        
    var ugufllhp = ganpidnd.has_setting("gamedev_assistant/development_mode") and ganpidnd.get_setting('gamedev_assistant/development_mode') == true    
    if ugufllhp:
        kgipeyis()
    
    if ganpidnd.has_setting("gamedev_assistant/validated"):
        if ganpidnd.get_setting("gamedev_assistant/validated") == true:
            jnodkrnq()
            yuvrqhzh(true)
                        
                                                             
            jloldkky.rkzcjncs(true)
            return
                                          
    elif !ganpidnd.has_setting("gamedev_assistant/onboarding_shown"):
        kgipeyis()
        ganpidnd.set_setting("gamedev_assistant/onboarding_shown", true)
        
    bxfhwegd(pfpwgqhw, "Settings")

func bxfhwegd (tisbykqp, hxedyxhf):
    vtxkafri.visible = false
    wnggyvne.visible = false
    pfpwgqhw.visible = false
    
                                                 
    tisbykqp.visible = true
    tisbykqp._on_open()
    
    ytiqnbbm.text = hxedyxhf
    
    yjksmhvt = tisbykqp == wnggyvne
    
                       
    jloldkky.yjpopcuv.emit()
    
                                                                
                                                           
                                       

func sqgwcqfv():
    bxfhwegd(vtxkafri, "Conversations")

func jnodkrnq():
    ivddsahv.fipugthy()
    bxfhwegd(wnggyvne, "New Conversation")
    wnggyvne.fnnfodqx()
    jloldkky.yjpopcuv.emit()

func kjezrtol():
    if pfpwgqhw.visible:
        return
    
    bxfhwegd(pfpwgqhw, "Settings")

func hvmjihvs (fmcfahdz : Conversation):
    ivddsahv.zjuxgbvd(fmcfahdz.id)
    bxfhwegd(wnggyvne, "Chat")

func yuvrqhzh (bnddnzez : bool):
    harglvrj = bnddnzez
    idgfbfgh.disabled = !bnddnzez
    kiodhthh.disabled = !bnddnzez
    
                                                               
func lupcgeuj(vdpfguax, param2 = ""):
                                                                                       
                                                            
    
    var fmbullmu = AcceptDialog.new()
    fmbullmu.get_ok_button().text = "Close"
    
                                                                                 
    if vdpfguax is bool:
                                                             
        var bttzrsmd = vdpfguax
        var noggtowd = param2
        
                                                   
        if bttzrsmd:
            fmbullmu.title = "GameDev Assistant Update"
            fmbullmu.dialog_text = "An update is available! Latest version: " + noggtowd + ". Go to https://app.gamedevassistant.com to download it."
            add_child(fmbullmu)
            fmbullmu.popup_centered()
    else:
                                                           
        var xfmcfgdb = vdpfguax
        fmbullmu.title = "GameDev Assistant Update"
        fmbullmu.dialog_text = xfmcfgdb
        add_child(fmbullmu)
        fmbullmu.popup_centered()

func kgipeyis():
    var xwijqtpl = AcceptDialog.new()
    xwijqtpl.title = "Welcome Aboard! 🚀"
    xwijqtpl.dialog_text = "Welcome to GameDev Assistant by Zenva!\n\n🌟 To get started:\n1. Find the Assistant tab (next to Inspector, Node, etc, use arrows < > to find it)\n2. Enter your token in Settings\n3. Start a chat with the + button\n4. Switch between Chat and Agent mode to find your perfect workflow\n\n\nHappy gamedev! 🎮"
    xwijqtpl.ok_button_text = "Close"
    xwijqtpl.dialog_hide_on_ok = true
    add_child(xwijqtpl)
    xwijqtpl.popup_centered()

func qqkfjbkp():
    return ivddsahv
