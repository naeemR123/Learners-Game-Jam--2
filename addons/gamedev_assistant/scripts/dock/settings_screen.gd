                                  
@tool
extends GDAScreenBase

var opiofbqo : Label
var zudkdzta : LineEdit
var ogltymmh : CheckButton
var ekfgjtnb : Button
var ygtpmhrg : RichTextLabel
var hdctrjeh : RichTextLabel
var liznshrm : RichTextLabel
var zbqppklm : Button
var upixhody : LineEdit
var hxwafmmi : Button
var nagdaybw : Button
var sptxurwg : String
var oxrjxsxz : CheckButton

const bcwboohh : String = "gamedev_assistant/hide_token"
const gvehtnqj : String = "gamedev_assistant/validated"
const bmwbdlok : String = "gamedev_assistant/custom_instructions"
const ktrrcult : String = "gamedev_assistant/add_openscripts"

@onready var pggmeylp = $".."
@onready var wwomrexd = $"../APIManager"
@onready var iaadrxmn = $"VBoxContainer/CustomInput"

var yancjpgv : bool

func _ready ():
    wwomrexd.nrinajro.connect(_on_validate_token_received)
    wwomrexd.apwgvoge.connect(_on_check_updates_received)
    wwomrexd.agqfwpxl.connect(rggvivrh)
    
    eoyvmdqg()
    
                                             
    ogltymmh.toggled.connect(qvgykfxz)
    ekfgjtnb.pressed.connect(sofhmgmn)
    hxwafmmi.pressed.connect(nctfgmca)
    nagdaybw.pressed.connect(vklrkerg)
    zudkdzta.text_changed.connect(mdxyvefo)
    oxrjxsxz.toggled.connect(imdllact)
    
    ygtpmhrg.visible = false
    hdctrjeh.visible = false
    liznshrm.visible = false
    
    var yxsroqcj = EditorInterface.get_editor_settings()       
    
    yxsroqcj.set_setting("gamedev_assistant/version_identifier", "93LDJHKS")
    
    yancjpgv = yxsroqcj.has_setting("gamedev_assistant/development_mode") and yxsroqcj.get_setting('gamedev_assistant/development_mode') == true    
    if not yancjpgv:
        yxsroqcj.set_setting("gamedev_assistant/endpoint", "https://app.gamedevassistant.com")
        sptxurwg = "gamedev_assistant/token"
    else:
        yxsroqcj.set_setting("gamedev_assistant/endpoint", "http://localhost:3000")
        sptxurwg = "gamedev_assistant/token_dev"
        print("Development mode")
        
    wwomrexd.olntksvi()
    
                                                                         
                                                  
func eoyvmdqg ():
    opiofbqo = $VBoxContainer/EnterTokenPrompt
    zudkdzta = $VBoxContainer/Token_Input
    ogltymmh = $VBoxContainer/HideToken
    ekfgjtnb = $VBoxContainer/ValidateButton
    ygtpmhrg = $VBoxContainer/TokenValidationSuccess
    hdctrjeh = $VBoxContainer/TokenValidationError
    liznshrm = $VBoxContainer/TokenValidationProgress
    hxwafmmi = $VBoxContainer/AccountButton
    nagdaybw = $VBoxContainer/UpdatesButton
    oxrjxsxz = $VBoxContainer/OpenScriptsContainer/OpenScriptsToggle

func qvgykfxz (hpgjpkog):
    zudkdzta.secret = hpgjpkog
    
    var dwuxbukt = EditorInterface.get_editor_settings()
    dwuxbukt.set_setting(bcwboohh, ogltymmh.button_pressed)

func mdxyvefo (duurfhoj):
    if len(zudkdzta.text) == 0:
        opiofbqo.visible = true
    else:
        opiofbqo.visible = false
    
    pggmeylp.yuvrqhzh(false)
    
    ygtpmhrg.visible = false
    hdctrjeh.visible = false
    liznshrm.visible = false
    
    var xovqbeli = EditorInterface.get_editor_settings()
    xovqbeli.set_setting(sptxurwg, zudkdzta.text)

func sofhmgmn ():
    ekfgjtnb.disabled = true
    ygtpmhrg.visible = false
    hdctrjeh.visible = false
    liznshrm.visible = true
    wwomrexd.xujuzqoa()

                                                        
func _on_validate_token_received (rptlhwiv : bool, gakxoigs : String):
    liznshrm.visible = false
    ekfgjtnb.disabled = false
    
    if rptlhwiv:
        ygtpmhrg.visible = true
        ygtpmhrg.text = "Token has been validated!"
        
        var dufjprmu = EditorInterface.get_editor_settings()
        dufjprmu.set_setting(gvehtnqj, true)
        
        pggmeylp.yuvrqhzh(true)
    else:
        hdctrjeh.visible = true
        hdctrjeh.text = gakxoigs

                                                  
                                                  
func _on_open ():
    eoyvmdqg()
    var kamubdwi = EditorInterface.get_editor_settings()
    
    if kamubdwi.has_setting(sptxurwg):
        zudkdzta.text = kamubdwi.get_setting(sptxurwg)
    
    if kamubdwi.has_setting(bcwboohh):
        ogltymmh.button_pressed = kamubdwi.get_setting(bcwboohh)
    
    if kamubdwi.has_setting(ktrrcult):
        oxrjxsxz.button_pressed = kamubdwi.get_setting(ktrrcult)
    
    zudkdzta.secret = ogltymmh.button_pressed
    
    if len(zudkdzta.text) == 0:
        opiofbqo.visible = true
    else:
        opiofbqo.visible = false
        
    if kamubdwi.has_setting(bmwbdlok):
        iaadrxmn.text = kamubdwi.get_setting(bmwbdlok)

func nctfgmca():
    OS.shell_open("https://app.gamedevassistant.com/profile")
    
func vklrkerg():
    ygtpmhrg.visible = false
    hdctrjeh.visible = false
    liznshrm.visible = true
    
    wwomrexd.rkzcjncs()

func _on_check_updates_received(wsupjrqp: bool, diuutvls: String):
    liznshrm.visible = false
    
    if wsupjrqp:
        ygtpmhrg.visible = true
        ygtpmhrg.text = "An update is available! Latest version: " + diuutvls + ". Click 'Manage Account' to download it."
    else:
        ygtpmhrg.visible = true
        ygtpmhrg.text = "You are already in the latest version"

func rggvivrh(smjwzgne: String):
    liznshrm.visible = false
    hdctrjeh.visible = true
    hdctrjeh.text = smjwzgne
    
func imdllact (nzfsbmtj):
    var ndkvyeph = EditorInterface.get_editor_settings()
    ndkvyeph.set_setting(ktrrcult, oxrjxsxz.button_pressed)
