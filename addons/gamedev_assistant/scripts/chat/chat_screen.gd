                                                       
@tool
extends GDAScreenBase

signal ynsjnasz

var sleoypka : RichTextLabel = null

@onready var nrwdayyb : TextEdit = $Footer/PromptInput
@onready var lgwvuihd : Button = $Footer/SendPromptButton
@onready var fqpygdrb : Control = $Footer
@onready var osfzpgjy : Control = $Body

@onready var wsjjotez = $"../APIManager"
@onready var uohokutw = $"../ActionManager"

var hnsgilay = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_UserPrompt.tscn")
var kqbnqnee = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ServerResponse.tscn")
var snhqqtfo = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_ErrorMessage.tscn")
const kzvpdeuj = preload("res://addons/gamedev_assistant/scripts/chat/markdown_to_bbcode.gd")
var oohxhybu = preload("res://addons/gamedev_assistant/scripts/chat/message_tagger.gd").new()
var zbgtiuts = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockResponse.tscn")
var fpimppud = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_CodeBlockUser.tscn")
var sqsqijqy = preload("res://addons/gamedev_assistant/dock/scenes/chat/Chat_Spacing.tscn")

var xrjgtzha := false
var royaxhij: String = ""

                                                   
var gcyjaose : String = ""
var sreezxfj : String = ""
var zhsgqvdf  : String = ""
var dvnltken : String = ""
var mgzvbyao  : String = ""

var zvodnnyg : int = -1

@onready var mkpjaltp = $Body/MessagesContainer
@onready var illyuhdb = $Body/MessagesContainer/ThinkingLabel
@onready var hjgbgsoy = $Bottom/AddContext
@onready var egxzshyy : CheckButton = $Bottom/ReasoningToggle
@onready var gfttvzgo = $Body/MessagesContainer/RatingContainer
@onready var dbjicuis = $Bottom/Mode

@onready var gijfzhgi = preload("res://addons/gamedev_assistant/dock/icons/stop.png")  
@onready var xvgkttti = preload("res://addons/gamedev_assistant/dock/icons/arrowUp.png")  

var pacwzfrl = [
    "",
    " @OpenScripts ",
    " @Output ",
    " @Docs ",
    " @GitDiff ",
    " @ProjectSettings"
]

@onready var gxenjgig = $"../ConversationManager"

var waiting_nonthinking = "Thinking ⚡"
var waiting_thinking = "Reasoning ⌛ This could take multiple minutes"

var notice_actions_nonthinking = "Generating one-click actions ⌛ To skip, press ■"
var notice_actions_thinking = "Generating one-click actions ⌛ To skip, press ■"


func _ready ():
    wsjjotez.hmjvhfxe.connect(yyikacab)
    wsjjotez.edbyckzj.connect(lsoofvbt)
    
    gxenjgig.uulcclje.connect(djtnohdb)
    nrwdayyb.gzopntpm.connect(pbjhrbxh)
    
                       
    wsjjotez.xifwqalw.connect(gnpcxmot)
    wsjjotez.hudonhfc.connect(pedalnke)
    wsjjotez.hizgvnpl.connect(fpbrrjrp)
    wsjjotez.celmjbwb.connect(wfufjpoo)

    hjgbgsoy.item_selected.connect(asgipbff)    
    lgwvuihd.pressed.connect(knlrroul)   
    
    gfttvzgo.get_node("UpButton").pressed.connect(qgebrpcb)
    gfttvzgo.get_node("DownButton").pressed.connect(bcvmvdhy)
    gfttvzgo.visible = false 

func _on_open ():
    nrwdayyb.text = ""
    illyuhdb.visible = false
    gfttvzgo.visible = false 
    eqqqnhhs(false)
    mvgdrjtm()
    hjgbgsoy.selected = 0
    royaxhij = ''
    

                                                            
func fnnfodqx ():
    xrjgtzha = true
    eqqqnhhs(true)
    zvodnnyg = -1
    gfttvzgo.visible = false
    oohxhybu.knboekch()
    
                    
    sreezxfj = ""
    zhsgqvdf  = ""
    dvnltken = ""
    mgzvbyao  = ""
    gcyjaose = ""
    
                          
    var kwjhhjdo = EditorInterface.get_editor_settings()
    var braklqwd = kwjhhjdo.has_setting("gamedev_assistant/add_openscripts") and kwjhhjdo.get_setting('gamedev_assistant/add_openscripts') == true    
    if braklqwd:
        nrwdayyb.text = "\n@OpenScripts"
    
                                 
    nrwdayyb.grab_focus()

func gnpcxmot(paqteoni: String, mnmqheir: int, jwjcdpjd: int) -> void:
    if sleoypka == null:
        sleoypka = kqbnqnee.instantiate()
        sleoypka.bbcode_enabled = true
        mkpjaltp.add_child(sleoypka)
        var kigwupnr = sqsqijqy.instantiate()
        mkpjaltp.add_child(kigwupnr)
        illyuhdb.visible = false
        royaxhij = paqteoni
        
        if jwjcdpjd != -1:
            zvodnnyg = jwjcdpjd
    else:
        royaxhij += paqteoni
        
                                                  
    sleoypka.text = kzvpdeuj.zlxkhaha(royaxhij)
    
                                                                     
    if not sleoypka.meta_clicked.is_connected(loqzqgcy):  
        sleoypka.meta_clicked.connect(loqzqgcy)  
    
    if mnmqheir > 0:
        gxenjgig.pdcvcxsj(mnmqheir)

func fpbrrjrp(czbavnqd: int, jyefhjuq: int) -> void:
    if sleoypka:
        sleoypka.visible = false

                                                                
    btcosjji(royaxhij, kqbnqnee, mkpjaltp, zbgtiuts)
    
                              
    mkpjaltp.move_child(illyuhdb, mkpjaltp.get_child_count() - 1)
    illyuhdb.visible = true
    illyuhdb.text = notice_actions_nonthinking

func pedalnke(tebfgpdn: int, mhgnjlmb: int) -> void:
                                         
    if sleoypka:
        sleoypka.queue_free()
        sleoypka = null
        
    illyuhdb.visible = false
    
                                                    
    mkpjaltp.move_child(gfttvzgo, mkpjaltp.get_child_count() - 1)
    gfttvzgo.visible = mhgnjlmb > 0
    
                          
    var jditrtra = uohokutw.kofqnnoc(royaxhij, mhgnjlmb)
    uohokutw.bdplldig(jditrtra, mkpjaltp)

    royaxhij = ""
    eqqqnhhs(true)
    illyuhdb.visible = false
    lgwvuihd.icon = xvgkttti

func wfufjpoo(trbcruej: String):
    razkdifo(trbcruej)
    eqqqnhhs(true)
    illyuhdb.visible = false
    sleoypka = null
    lgwvuihd.icon = xvgkttti

func knlrroul():  
    if wsjjotez.cbzghnwn():  
                                         
        wsjjotez.yjpopcuv.emit()  
        
                                             
        if sleoypka:
            sleoypka.queue_free()
            sleoypka = null
        
        eqqqnhhs(true)  
        lgwvuihd.icon = xvgkttti  
        
        if not illyuhdb.visible:
                                                                        
            btcosjji(royaxhij, kqbnqnee, mkpjaltp, zbgtiuts)
        
        illyuhdb.visible = false  
        
                                                   
        mkpjaltp.move_child(gfttvzgo, mkpjaltp.get_child_count() - 1)
        gfttvzgo.visible = zvodnnyg > 0

    else:  
                                             
        olvtuhan()  

func olvtuhan():
                                                        
    uohokutw.rdfwvlxa()
    
    gfttvzgo.visible = false
    
    zvodnnyg = -1
    
    if len(nrwdayyb.text) < 1:
        return
    
    var vvvmmxgj = nrwdayyb.text

                                                        
    var oxtsfsbt := false
    if xrjgtzha:
        var curhmwih = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
        dvnltken = oohxhybu.hkyyfanc("", curhmwih)
        mgzvbyao  = oohxhybu.mydpeuby("", curhmwih)
        gcyjaose = "[gds_context]Current project context:[/gds_context]\n" \
            + dvnltken + "\n" + mgzvbyao
        oxtsfsbt = true
    else:
        oxtsfsbt = erpscwyx()

    if oxtsfsbt and gcyjaose != "":
        vvvmmxgj += gcyjaose
                          
        sreezxfj = dvnltken
        zhsgqvdf  = mgzvbyao

    xrjgtzha = false

    if Engine.is_editor_hint():
        var curhmwih = Engine.get_singleton("EditorInterface")
        vvvmmxgj = oohxhybu.zppctpmw(vvvmmxgj, curhmwih)
        
    var orwzyvkb = egxzshyy.button_pressed
    var kfzikwcz : int = dbjicuis.selected
    var keszfcht : String
    
    if kfzikwcz == 0:
        keszfcht = "CHAT"
    else:
        keszfcht = "AGENT"        
    
    wsjjotez.qoazlqdk(vvvmmxgj, orwzyvkb, keszfcht)
    ffjfnaul(nrwdayyb.text)                               
    eqqqnhhs(false)
    nrwdayyb.text = ""
    
    if orwzyvkb:
        illyuhdb.text = waiting_thinking
    else:
        illyuhdb.text = waiting_nonthinking
        
    illyuhdb.visible = true
    mkpjaltp.move_child(illyuhdb, mkpjaltp.get_child_count() - 1)
    
                                               
    ynsjnasz.emit()
    
func eqqqnhhs (dzksaeol : bool):
    if dzksaeol:  
        lgwvuihd.icon = xvgkttti  
    else:  
        lgwvuihd.icon = gijfzhgi  

func yyikacab (gcimyhps : String, qbkecjfk : int):
    luqzfyfn(gcimyhps)
    eqqqnhhs(true)
    illyuhdb.visible = false

func lsoofvbt (ytraotne : String):
    razkdifo(ytraotne)
    eqqqnhhs(true)
    illyuhdb.visible = false

func ffjfnaul(nddswqoz: String):
                                                                               
    btcosjji(nddswqoz, hnsgilay, mkpjaltp, fpimppud)
    
    var ecbmbtvk = sqsqijqy.instantiate()
    mkpjaltp.add_child(ecbmbtvk)


func luqzfyfn(lxzpxyhw: String):
                                                                                
    btcosjji(lxzpxyhw, kqbnqnee, mkpjaltp, zbgtiuts)
    
    var upyhthgw = sqsqijqy.instantiate()
    mkpjaltp.add_child(upyhthgw)

func razkdifo (irrageka : String):
    var cgmwbwbs = snhqqtfo.instantiate()
    mkpjaltp.add_child(cgmwbwbs)
    cgmwbwbs.text = irrageka

func mvgdrjtm ():
    for node in mkpjaltp.get_children():
        if node == illyuhdb or node == gfttvzgo:
            continue
        node.queue_free()
    mkpjaltp.custom_minimum_size = Vector2.ZERO
    
    ynsjnasz.emit()
    
                  
    oohxhybu.knboekch()
    
                            
    sreezxfj = ""
    zhsgqvdf  = ""
    dvnltken = ""
    mgzvbyao  = ""
    gcyjaose = ""

func djtnohdb ():
    var fmuvwafw = gxenjgig.uziqrmqg()
    mvgdrjtm()
    
    for msg in fmuvwafw.messages:
        if msg.role == "user":
            ffjfnaul(msg.content)
        elif msg.role == "assistant":
            luqzfyfn(msg.content)
    
    eqqqnhhs(true)

func asgipbff(jdhjyqww: int):
    if jdhjyqww >= 0 and jdhjyqww < pacwzfrl.size():
        nrwdayyb.text += " " + pacwzfrl[jdhjyqww]
        hjgbgsoy.select(0)

func loqzqgcy(fmjkshfw):
    OS.shell_open(str(fmjkshfw))

                                                
func ryuopbxf(jjkkfbae: String) -> String:
    
    var qpbizmyq = RegEx.new()
                                 
    qpbizmyq.compile("\\[gds_context\\](.|\\n)*?\\[/gds_context\\]")
    jjkkfbae = qpbizmyq.sub(jjkkfbae, "", true)
    
                                       
    qpbizmyq.compile("<internal_tool_use>(.|\\n)*?</internal_tool_use>")
    return qpbizmyq.sub(jjkkfbae, "", true)
    
                                                
func ecdugbjn(usksrjwx: String) -> String:
        
    var llsfgwxf = RegEx.new()
    llsfgwxf.compile("\\[gds_actions\\](.|\\n)*?\\[/gds_actions\\]")
    return llsfgwxf.sub(usksrjwx, "", true)

func iieakaig(edeyjzhe: String):
    edeyjzhe = edeyjzhe.replace(notice_actions_nonthinking, '').replace(notice_actions_thinking, '').strip_edges()
    return edeyjzhe
    
func btcosjji(ycoojvlq: String, pqimsbmt: PackedScene, rfspzgol: Node, lkxzrrqj: PackedScene) -> void:
    
    ycoojvlq = ycoojvlq.strip_edges()
    ycoojvlq = ryuopbxf(ycoojvlq)
    
                       
    var ozrtpjeu = kzvpdeuj.wdyafadg(ycoojvlq)

    for block in ozrtpjeu:
        if block["type"] == "text":
            var mwezcfee = pqimsbmt.instantiate()
            mwezcfee.bbcode_enabled = true
            rfspzgol.add_child(mwezcfee)
            
            var rngchtha = block["content"]
            
                                                      
            rngchtha = kzvpdeuj.xrufinik(rngchtha)
            rngchtha = kzvpdeuj.omxollrz(rngchtha)
            rngchtha = rngchtha.strip_edges()
            
            mwezcfee.text = rngchtha

                                 
            if not mwezcfee.meta_clicked.is_connected(loqzqgcy):
                mwezcfee.meta_clicked.connect(loqzqgcy)

        elif block["type"] == "code":
            var hjskfdjc = lkxzrrqj.instantiate()
            rfspzgol.add_child(hjskfdjc)
            hjskfdjc.text = block["content"]

                           
func erpscwyx() -> bool:
    var dtpgppxc = Engine.get_singleton("EditorInterface") if Engine.is_editor_hint() else null
    dvnltken = oohxhybu.hkyyfanc("", dtpgppxc)
    mgzvbyao  = oohxhybu.mydpeuby("", dtpgppxc)

    var nccsabva = dvnltken != sreezxfj
    var kghoyzgd  = mgzvbyao  != zhsgqvdf

    var ehoyktmi = []
    if nccsabva:
        ehoyktmi.append(dvnltken)
    if kghoyzgd:
        ehoyktmi.append(mgzvbyao)

    gcyjaose = ""
    if ehoyktmi.size() > 0:
        gcyjaose = "[gds_context]Current project context:[/gds_context]\n" + "\n".join(ehoyktmi)

    return nccsabva or kghoyzgd

                               
func pbjhrbxh() -> void:
    var nvlxgsag = not wsjjotez.cbzghnwn()
    if nvlxgsag:
        olvtuhan()
        
func qgebrpcb():
    if zvodnnyg > 0:
        wsjjotez.oxkuymyc(zvodnnyg, 5)
        gfttvzgo.visible = false                     

func bcvmvdhy():
    if zvodnnyg > 0:
        wsjjotez.oxkuymyc(zvodnnyg, 1)
        gfttvzgo.visible = false
