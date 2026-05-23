                                                       
@tool
extends Node

                                                 
                                      
                                   

signal nrinajro (validated : bool, error : String)

signal apwgvoge(update_available: bool, latest_version: String)
signal agqfwpxl(error: String)

signal hmjvhfxe (message : String, conv_id : int)
signal edbyckzj (error : String)
signal eajsjrje (message : String)

signal xcxxpngk (data)
signal iwufumws (error : String)

signal czvetcnr (data)
signal iaswqxwz (error : String)

signal xoyucvfi ()
signal miqfppqr (error : String)

signal lyxhzjdt ()
signal sbufsbte (error : String)

signal yjpopcuv

const igldrobv = 30
const iafvfvgt = 120
const jbzpnhsu = 60

var ojbyvxpy : bool 

              
signal xifwqalw(content: String, conv_id: int, message_id: int)
signal hudonhfc(conv_id: int, message_id: int)
signal hizgvnpl(conv_id: int, message_id: int)
signal celmjbwb(error: String)
var pvtrhfhk : HTTPClient
var fjvhrmyy = false
var fwcnmxwu = ""
var jpbdaoby = false

var gqyprpzm : String
var spzurhbz : String
var ybtpotjo : String
var cqmyaxav : String
var yndfndan : String
var snnnfzzz : String
var zvzorgna : String
var fbtwgoyp : String

var zazclxim : String:
    get:
        var lgiheqze = EditorInterface.get_editor_settings()
        var bmjftoxg = "null"
        ojbyvxpy = lgiheqze.has_setting("gamedev_assistant/development_mode") and lgiheqze.get_setting('gamedev_assistant/development_mode') == true
        
        if not ojbyvxpy and lgiheqze.has_setting("gamedev_assistant/token"):
            return lgiheqze.get_setting("gamedev_assistant/token")
        elif ojbyvxpy and lgiheqze.has_setting("gamedev_assistant/token_dev"):        
            return lgiheqze.get_setting("gamedev_assistant/token_dev")
                    
        return bmjftoxg

var epuzyeei = ["Content-type: application/json", "Authorization: Bearer " + zazclxim]

@onready var rorrzuzv = $"../ConversationManager"

@onready var mbvfecex : HTTPRequest = $ValidateToken
@onready var qxprcpfc : HTTPRequest = $SendMessage
@onready var xfwkcfkg : HTTPRequest = $GetConversationsList
@onready var rhusagrf : HTTPRequest = $GetConversation
@onready var cwrwtotq : HTTPRequest = $DeleteConversation
@onready var fljshzoe : HTTPRequest = $ToggleFavorite
@onready var raegzqyd : HTTPRequest = $CheckUpdates
@onready var zsqaufez : HTTPRequest = $TrackAction
@onready var zjnhwtbw : HTTPRequest = $RatingAction
@onready var jsxufsko : HTTPRequest = $EditScript

var euhdaiet = []

var kfkphagm : Button = null

func _ready ():
                                      
    pvtrhfhk = HTTPClient.new()
    
    mbvfecex.timeout = igldrobv                                         
    qxprcpfc.timeout = iafvfvgt                                           
    xfwkcfkg.timeout = igldrobv                                 
    rhusagrf.timeout = igldrobv                                       
    cwrwtotq.timeout = igldrobv                                    
    fljshzoe.timeout = igldrobv
    raegzqyd.timeout = igldrobv
    jsxufsko.timeout = jbzpnhsu
    
    mbvfecex.request_completed.connect(hqmmsxbp)
    qxprcpfc.request_completed.connect(efdyxbof)
    xfwkcfkg.request_completed.connect(eubyyodr)
    rhusagrf.request_completed.connect(bhyzttpg)
    cwrwtotq.request_completed.connect(qxkabglm)
    fljshzoe.request_completed.connect(xuirlssi)
    raegzqyd.request_completed.connect(csbsjpmh)
    jsxufsko.request_completed.connect(ryltcxpk)
    
    yjpopcuv.connect(axskujby)  
    
    olntksvi ()
    

func olntksvi ():
    var xtxqmmcb = EditorInterface.get_editor_settings()            
    if xtxqmmcb.has_setting("gamedev_assistant/endpoint"):          
        gqyprpzm = xtxqmmcb.get_setting("gamedev_assistant/endpoint")    
        spzurhbz = gqyprpzm + "/token/validate"                
        ybtpotjo = gqyprpzm + "/chat/message"                         
        cqmyaxav = gqyprpzm + "/chat/conversations"        
        yndfndan = gqyprpzm + "/chat/conversation/"
        snnnfzzz = gqyprpzm + "/chat/checkForUpdates"
        zvzorgna = gqyprpzm + "/chat/track-action"
        fbtwgoyp = gqyprpzm + "/chat/track-rating"

func xowxwnnt ():
    return ["Content-type: application/json", "Authorization: Bearer " + zazclxim]

func xujuzqoa ():
    var ckjenkth = mbvfecex.request(spzurhbz, xowxwnnt(), HTTPClient.METHOD_GET)

func qoazlqdk(dfbqlpwy: String, qrjklwxj: bool, xnxvoebm: String) -> void:
    
    qxprcpfc.timeout = igldrobv
    
                           
    fjvhrmyy = false
    jpbdaoby = false
    fwcnmxwu = ""
    
                                
    var zqubjvpa = gqyprpzm.begins_with("https://")
    var pirlkhsp = gqyprpzm.replace("http://", "").replace("https://", "")
    
                                       
    var hgiapgpv = -1
    if pirlkhsp.begins_with("localhost:"):
        var htupshwp = pirlkhsp.split(":")
        pirlkhsp = htupshwp[0]
        hgiapgpv = int(htupshwp[1])
        
    var qopncpgk: Error
    if zqubjvpa:
        qopncpgk = pvtrhfhk.connect_to_host(pirlkhsp, hgiapgpv, TLSOptions.client())
    else:
        qopncpgk = pvtrhfhk.connect_to_host(pirlkhsp, hgiapgpv)
        
    if qopncpgk != OK:
        celmjbwb.emit("Failed to connect: " + str(qopncpgk))
        return

    fjvhrmyy = true
    
                             
    var zxnqshmr = EditorInterface.get_editor_settings()
    var xosynvzc = zxnqshmr.get_setting("gamedev_assistant/version_identifier")
    
    var kmdxoveb = Engine.get_version_info()
    var rkyhcqec = "%d.%d" % [kmdxoveb.major, kmdxoveb.minor]
    
                                           
    var mockaktt = ""
    if zxnqshmr.has_setting("gamedev_assistant/custom_instructions"):
        mockaktt = zxnqshmr.get_setting("gamedev_assistant/custom_instructions")
    
    
                              
    var fpedopuf = { 
        "content": dfbqlpwy, 
        "useThinking": qrjklwxj,
        "releaseUniqueIdentifier": xosynvzc,
        "godotVersion": rkyhcqec,
        "mode": xnxvoebm,
        "customInstructions": mockaktt
    }
    
    var vpwuadzd = rorrzuzv.uziqrmqg()
    
    if vpwuadzd and vpwuadzd.id > 0:
        fpedopuf["conversationId"] = vpwuadzd.id
        
                                                            
    
                                                
    oilazydy(fpedopuf)
    
    eajsjrje.emit(dfbqlpwy)

func yoleiwce ():
    var zfvxlmed = xfwkcfkg.request(cqmyaxav, xowxwnnt(), HTTPClient.METHOD_GET)

func get_conversation (hblosjdq : int):
    var dhllxwwq = yndfndan + str(hblosjdq)
    var oatwqsde = rhusagrf.request(dhllxwwq, xowxwnnt(), HTTPClient.METHOD_GET)

func cdojqhzs (tikcqbrg : int):
    var rzzngafu = yndfndan + str(tikcqbrg)
    var atxvlcju = cwrwtotq.request(rzzngafu, xowxwnnt(), HTTPClient.METHOD_DELETE)

func pvxvfono (vetsatcf : int):
    var jvxmyfst = yndfndan + str(vetsatcf) + "/toggle-favorite"
    var iwrswmfi = fljshzoe.request(jvxmyfst, xowxwnnt(), HTTPClient.METHOD_POST)

func hqmmsxbp(rlucwljk: int, kdzqurqk: int, xdbdfpai: PackedStringArray, nucuzkok: PackedByteArray):
                                
    if rlucwljk != HTTPRequest.RESULT_SUCCESS:
        nrinajro.emit(false, "Network error (Code: " + str(rlucwljk) + ")")
        return
        
    var rmiznitx = jfpptpyj(nucuzkok)
    if not rmiznitx is Dictionary:
        nrinajro.emit(false, "Response error (Code: " + str(kdzqurqk) + ")")
        return
        
    var tlwwlmsn = rmiznitx.get("success", false)
    var buxlqkjc = rmiznitx.get("error", "Response code: " + str(kdzqurqk))
    
    nrinajro.emit(tlwwlmsn, buxlqkjc)

                                                     
func efdyxbof(rzppxkoi, hyghjoqo, epfewkeo, koksefij):
    
    if rzppxkoi != HTTPRequest.RESULT_SUCCESS:
        edbyckzj.emit("Network error (Code: " + str(rzppxkoi) + ")")
        return
        
    var unzlcgug = jfpptpyj(koksefij)
    if not unzlcgug is Dictionary:
        edbyckzj.emit("Response error (Code: " + str(hyghjoqo) + ")")
        return
    
    if hyghjoqo == 201:
        var tpbnjvsf = unzlcgug.get("content", "")
        var jzypjxho = int(unzlcgug.get("conversationId", -1))
        hmjvhfxe.emit(tpbnjvsf, jzypjxho)
    else:
        edbyckzj.emit(unzlcgug.get("error", "Response code: " + str(hyghjoqo)))

                                                                    
func eubyyodr(joskcmsv, eizjtzcx, mewqntwc, qpxawvdp):
    if joskcmsv != HTTPRequest.RESULT_SUCCESS:
        iwufumws.emit("Network error (Code: " + str(joskcmsv) + ")")
        return
        
    var xwsrmydq = jfpptpyj(qpxawvdp)
    
    if eizjtzcx == 200:
        xcxxpngk.emit(xwsrmydq)
    else:
        if xwsrmydq is Dictionary:
            iwufumws.emit(xwsrmydq.get("error", "Response code: " + str(eizjtzcx)))
        else:
            iwufumws.emit("Response error (Code: " + str(eizjtzcx) + ")")

                                                                
func bhyzttpg(uengjcop, rgoiallj, kkiljfuy, ahqsxolj):
    if uengjcop != HTTPRequest.RESULT_SUCCESS:
                                                              
        printerr("[GameDev Assistant] Get conversation network error (Code: " + str(uengjcop) + ")")
        return
        
    var tcypvnzz = jfpptpyj(ahqsxolj)
    if not tcypvnzz is Dictionary:
        printerr("[GameDev Assistant] Get conversation response error (Code: " + str(rgoiallj) + ")")
        return
        
    czvetcnr.emit(tcypvnzz)

                                                                                         
func qxkabglm(sxztlviy, memzgcca, ygzhxkgh, gambdxyx):
    if sxztlviy != HTTPRequest.RESULT_SUCCESS:
                                                                          
        printerr("[GameDev Assistant] Delete conversation network error (Code: " + str(sxztlviy) + ")")
        return
        
    if memzgcca == 204:
        xoyucvfi.emit()
    else:
        var vjmjcudt = jfpptpyj(gambdxyx)
        var kbddpxnw = "[GameDev Assistant] Response code: " + str(memzgcca)
        if vjmjcudt is Dictionary:
            kbddpxnw = vjmjcudt.get("error", kbddpxnw)
        miqfppqr.emit(kbddpxnw)

                                                                                                       
func xuirlssi(upvcpoyf, cckgsovg, ahzjjxvi, dejnapoz):
    if upvcpoyf != HTTPRequest.RESULT_SUCCESS:
                                                                      
        printerr("[GameDev Assistant] Toggle favorite network error (Code: " + str(upvcpoyf) + ")")
        return
        
    if cckgsovg == 200:
        lyxhzjdt.emit()
    else:
        var jcjgukki = jfpptpyj(dejnapoz)
        var rltdhqfm = "[GameDev Assistant] Response code: " + str(cckgsovg)
        if jcjgukki is Dictionary:
            rltdhqfm = jcjgukki.get("error", rltdhqfm)
        sbufsbte.emit(rltdhqfm)

func jfpptpyj (eomlaaja):
    var cvhpgwsz = JSON.new()
    var zpjfmygb = cvhpgwsz.parse(eomlaaja.get_string_from_utf8())
    if zpjfmygb != OK:
        return null
    return cvhpgwsz.get_data()

func oilazydy(guaybdmm: Dictionary) -> void:
    while fjvhrmyy:
        pvtrhfhk.poll()
        
        match pvtrhfhk.get_status():
            HTTPClient.STATUS_CONNECTION_ERROR:
                celmjbwb.emit("Connection error")
                axskujby()
                return
            HTTPClient.STATUS_DISCONNECTED:
                celmjbwb.emit("Disconnected")
                axskujby()
                return
            
            HTTPClient.STATUS_CONNECTED:
                if not jpbdaoby:
                    sgifxvrb(guaybdmm)
                
            HTTPClient.STATUS_BODY:
                trpgeoam()
        
        await get_tree().process_frame

func sgifxvrb(lwunvaym: Dictionary) -> void:
    if jpbdaoby:
        return
    jpbdaoby = true
    
    var iiklblzh = JSON.new()
    var nejpndfs = iiklblzh.stringify(lwunvaym)
    var qmtiwvhz = PackedStringArray([
        "Content-Type: application/json",
        "Authorization: Bearer " + zazclxim
    ])
    
    var luvmbhqu = pvtrhfhk.request(
        HTTPClient.METHOD_POST,
        ybtpotjo.replace(gqyprpzm, ""),                                        
        qmtiwvhz,
        nejpndfs
    )
    
    if luvmbhqu != OK:
        celmjbwb.emit("Failed to send request: " + str(luvmbhqu))
        fjvhrmyy = false
        jpbdaoby = false

func trpgeoam() -> void:
    while pvtrhfhk.get_status() == HTTPClient.STATUS_BODY:
        var bxatnpfr = pvtrhfhk.read_response_body_chunk()
        if bxatnpfr.size() == 0:
            break
            
        fwcnmxwu += bxatnpfr.get_string_from_utf8()
        
        oqrwevhi()

func oqrwevhi() -> void:
    
    var kswdfyfx
    var xalobjue
    var miryzosv
    
    if pvtrhfhk.get_response_code() != 200:
        fjvhrmyy = false
        
        kswdfyfx = JSON.new()
        xalobjue = kswdfyfx.parse(fwcnmxwu)
        
        if xalobjue == OK:
            miryzosv = kswdfyfx.get_data()
            if miryzosv.has("error"):                
                celmjbwb.emit(miryzosv["error"])
            elif miryzosv.has("message"):                
                celmjbwb.emit(miryzosv["message"])
            else:
                celmjbwb.emit("Unknown server error, please try again later")
        else: 
            celmjbwb.emit("Could not parse server response. Received from server: " + fwcnmxwu)
    
    var nzkgwlse = fwcnmxwu.split("\n\n")
    
                                                                                 
    for i in range(nzkgwlse.size() - 1):
        var umhhyejo: String = nzkgwlse[i]
        if umhhyejo.find("data:") != -1:
            var rumhtvpm = umhhyejo.split("\n")
            for line in rumhtvpm:
                if line.begins_with("data:"):
                    var ipdjwecg = line.substr(5).strip_edges()
                                                               
                    
                    kswdfyfx = JSON.new()
                    xalobjue = kswdfyfx.parse(ipdjwecg)
                    
                    if xalobjue == OK:
                        miryzosv = kswdfyfx.get_data()
                        
                        if miryzosv is Dictionary:
                            if miryzosv.has("error"):
                                printerr("Server error: ", miryzosv["error"])
                                celmjbwb.emit(miryzosv["error"])
                                axskujby()
                                return
                            
                            if miryzosv.has("done") and miryzosv["done"] == true:
                                fjvhrmyy = false
                                                                
                                hudonhfc.emit(
                                    int(miryzosv.get("conversationId", -1)),
                                    int(miryzosv.get("messageId", -1))
                                )
                                axskujby()
                                
                            elif miryzosv.has("beforeActions"):
                                hizgvnpl.emit(
                                    int(miryzosv.get("conversationId", -1)),
                                    int(miryzosv.get("messageId", -1))
                                )
                                
                            elif miryzosv.has("content"):
                                
                                if (typeof(miryzosv.get("messageId")) != TYPE_INT and typeof(miryzosv.get("messageId")) != TYPE_FLOAT) or (typeof(miryzosv.get("conversationId")) != TYPE_INT and typeof(miryzosv.get("conversationId")) != TYPE_FLOAT):
                                    celmjbwb.emit("Invalid data coming from the server")
                                    axskujby()
                                    return                                   
                            
                                xifwqalw.emit(
                                    str(miryzosv["content"]),
                                    int(miryzosv.get("conversationId", -1)),
                                    int(miryzosv.get("messageId", -1))
                                )
                        
                                               
    fwcnmxwu = nzkgwlse[nzkgwlse.size() - 1]
    
func axskujby():  
    fjvhrmyy = false  
    pvtrhfhk.close()            

                                                                  
func rkzcjncs(fdbluurb: bool = false):
    var jyvcxukt = EditorInterface.get_editor_settings()       
    var vtixphlx = jyvcxukt.get_setting("gamedev_assistant/version_identifier")
    
    var ujuxxjkc = {
        "releaseUniqueIdentifier": vtixphlx,
        "isInit": fdbluurb
    }
    var oezhrtce = JSON.new()
    var kypnvnmd = oezhrtce.stringify(ujuxxjkc)
    var ijajpbgi = raegzqyd.request(snnnfzzz, xowxwnnt(), HTTPClient.METHOD_POST, kypnvnmd)

                                            
func csbsjpmh(xzzgwjdr, aqgcgspf, ahixdkiz, enrgsyrj):
    if xzzgwjdr != HTTPRequest.RESULT_SUCCESS:
        agqfwpxl.emit("[GameDev Assistant] Network error when checking for updates (Code: " + str(xzzgwjdr) + ")")
        return
        
    var hufumnsj = jfpptpyj(enrgsyrj)
    if not hufumnsj is Dictionary:
        agqfwpxl.emit("[GameDev Assistant] Response error when checking for updates (Code: " + str(aqgcgspf) + ")")
        return
    
    if aqgcgspf == 200:
        var ppltnoyd = hufumnsj.get("updateAvailable", false)
        var koifpoqq = hufumnsj.get("latestVersion", "")
        
        apwgvoge.emit(ppltnoyd, koifpoqq)
    else:
        agqfwpxl.emit(hufumnsj.get("error", "Response code: " + str(aqgcgspf)))

func gjnrwvpr(qxjarvmq: int, iybtmofr: bool, ulrxxwri: String, pvkuomdn: String, nxpakpre: String, cklurtqw: String):
    var dzerelxj = {
        "messageId": qxjarvmq,
        "success": iybtmofr,
        "action_type": ulrxxwri,
        "node_type": pvkuomdn,
        "subresource_type": nxpakpre,
        "error_message": cklurtqw
    }
    euhdaiet.append(dzerelxj)
    htnqidwu()

                             
func htnqidwu():
    var client_status = zsqaufez.get_http_client_status()
                                                                                      
    if (client_status == HTTPClient.STATUS_DISCONNECTED or 
        client_status == HTTPClient.STATUS_CANT_RESOLVE or 
        client_status == HTTPClient.STATUS_CANT_CONNECT or 
        client_status == HTTPClient.STATUS_CONNECTION_ERROR or 
        client_status == HTTPClient.STATUS_TLS_HANDSHAKE_ERROR) and euhdaiet.size() > 0:
        
        var xiuryxbf = euhdaiet.pop_front()
        var aiperlfe = JSON.new()
        var kkrsptva = aiperlfe.stringify(xiuryxbf)
        var lwgssmsy = xowxwnnt()
        var pkvgdafc = zsqaufez.request(zvzorgna, lwgssmsy, HTTPClient.METHOD_POST, kkrsptva)
        if pkvgdafc != OK:
            printerr("Failed to start track action request:", pkvgdafc)
            htnqidwu()                                  

func rjjfzbmc(evplqhae, gnmteeew, lrxrpbsz, hfvcfwhu):
    htnqidwu()                                      
    if evplqhae != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Track action failed:", evplqhae)
        return
        
    var olgmrket = jfpptpyj(hfvcfwhu)
    if not olgmrket is Dictionary:
        printerr("[GameDev Assistant] Invalid track action response")

func oxkuymyc(ymhggxfn: int, gzkxmfjz: int) -> void:
    var upllildm = {
        "messageId": ymhggxfn,
        "rating": gzkxmfjz
    }
    var pmuglrkn = JSON.new()
    var lgesakax = pmuglrkn.stringify(upllildm)
    var kutqeuft = xowxwnnt()
    var cmcbpidu = zjnhwtbw.request(fbtwgoyp, kutqeuft, HTTPClient.METHOD_POST, lgesakax)
    if cmcbpidu != OK:
        printerr("[GameDev Assistant] Failed to track rating:", cmcbpidu)

                                          
func sajeajzr(hlnwctgm, hplqsssf, injzwkfd, zjmnqtny):
    if hlnwctgm != HTTPRequest.RESULT_SUCCESS:
        printerr("[GameDev Assistant] Rating action failed:", hlnwctgm)
        return
        
    var evaxnjaw = jfpptpyj(zjmnqtny)
    if not evaxnjaw is Dictionary:
        printerr("[GameDev Assistant] Invalid rating response")
        return

func cbzghnwn():
    return fjvhrmyy
func saugzyjy(dhbbfwiw: Object) -> void:
    print("=== Methods ===")
    for method in dhbbfwiw.get_method_list():
        print(method["name"])
    
    print("\n=== Properties ===")
    for property in dhbbfwiw.get_property_list():
        print(property["name"])
    
    print("\n=== Signals ===")
    for signal_info in dhbbfwiw.get_signal_list():
        print(signal_info["name"])
        
func iaavjnqt(magpdwzd: String, iflhmyse: int, htckiiju: String, qntombjw: Button) -> void:
                                         
    kfkphagm = qntombjw
    
                                                                  
    var ciltsngi = $"../ActionManager"
    ciltsngi.pvbkfcft.emit("edit_script", true)
    qntombjw.text = "⌛Editing file %s" % magpdwzd

    var vyceqwdc = {
        "path": magpdwzd,
        "message_id": iflhmyse,
        "content": htckiiju
    }
    
    var xgtaryaz = JSON.new()
    var plreqgaj = xgtaryaz.stringify(vyceqwdc)
    var zgujrals = xowxwnnt()
                                                     
    
    var pqugvwll = gqyprpzm + "/editScript"
    var rgfavpqp = jsxufsko.request(pqugvwll, zgujrals, HTTPClient.METHOD_POST, plreqgaj)
    
    if rgfavpqp != OK:
        var pllsrfdv = "Failed to start edit_script request: " + str(rgfavpqp)
        push_error(pllsrfdv)
                                   
                                                      
        ciltsngi.tmvpeqiy.emit("edit_script", false,pllsrfdv, "", "", qntombjw)
        
func ryltcxpk(nkyrelwx: int, iiynxdsl: int, dcordspx: PackedStringArray, okhyayms: PackedByteArray) -> void:
    var jxrchils = $"../ActionManager"
    var rndddmne = kfkphagm

                                                                
    if nkyrelwx != HTTPRequest.RESULT_SUCCESS:
        var wcwcjuxa = "EditScript network request failed. Code: " + str(nkyrelwx)
        push_error(wcwcjuxa)
        jxrchils.tmvpeqiy.emit("edit_script", false, wcwcjuxa, "", "", rndddmne)
        return

                                                      
    var rxobqtom = jfpptpyj(okhyayms)
    if not rxobqtom is Dictionary:
        var wcwcjuxa = "Invalid response from server (not valid JSON)."
        push_error(wcwcjuxa)
        jxrchils.tmvpeqiy.emit("edit_script", false, wcwcjuxa, "", "", rndddmne)
        return

                                                         
    if rxobqtom.has("error"):
        var wcwcjuxa = "Server returned an error: " + str(rxobqtom["error"])
        push_error(wcwcjuxa)
        jxrchils.tmvpeqiy.emit("edit_script", false, wcwcjuxa, "", "", rndddmne)
        return

    var pflzhpnk = rxobqtom.get("path", "")
    var hlkzllgo = rxobqtom.get("content", "")

                                                  
    if pflzhpnk.is_empty():
        var wcwcjuxa = "Incomplete data in EditScript response (path or content missing)."
        push_error(wcwcjuxa)
        jxrchils.tmvpeqiy.emit("edit_script", false, wcwcjuxa, "", "", rndddmne)
        return

                                                         
    var smtpwtqz = FileAccess.open(pflzhpnk, FileAccess.WRITE)
    if smtpwtqz:
        smtpwtqz.store_string(hlkzllgo)
        smtpwtqz.close()

                                                        
        var pyrqcgdk = ResourceLoader.load(pflzhpnk, "Script", ResourceLoader.CACHE_MODE_IGNORE)
        await get_tree().process_frame
        
                                                                          
                                                                                 
        var qrxlaeey = rndddmne.get_meta("action")
        rndddmne.text = "Edit {path}".format({"path": qrxlaeey.path})

        var mocqtowt = Engine.get_singleton("EditorInterface")
        var ajnytzhx = mocqtowt.get_script_editor()
        
                                                                                  
        var skdbmdyo = false
        for open_script in ajnytzhx.get_open_scripts():
            if open_script.resource_path == pflzhpnk:
                skdbmdyo = true
                break
        
                                                                                 
        mocqtowt.edit_script(pyrqcgdk)
        await get_tree().process_frame                                   
        
                                                                   
                                                                
        var xuwvdhaj = ajnytzhx.get_current_script()
        if xuwvdhaj and xuwvdhaj.resource_path == pflzhpnk:
            ajnytzhx.get_current_editor().get_base_editor().set_text(hlkzllgo)
            if skdbmdyo:
                push_warning("[GameDev Assistant] File updated: " + pflzhpnk + " (due to a Godot API limitation, it will appear as unsaved, but it has been saved to disk!)")
            else:
                print("[GameDev Assistant] File updated: " + pflzhpnk)
        else:
                                                                             
            push_error("[GameDev Assistant] Could not update the editor view for " + pflzhpnk + ", but the file has been saved to disk.")

        mocqtowt.get_resource_filesystem().scan()
        
        await get_tree().process_frame
        mocqtowt.edit_script(pyrqcgdk)                           

                                 
        jxrchils.tmvpeqiy.emit("edit_script", true, "", "", "", rndddmne)
    else:
                                                         
        var sxsufbxx = FileAccess.get_open_error()
        var wcwcjuxa = "Failed to write to script '%s'. Error: %s" % [pflzhpnk, error_string(sxsufbxx)]
        push_error("[GameDev Assistant] " + wcwcjuxa)
        jxrchils.tmvpeqiy.emit("edit_script", false, wcwcjuxa, "", "", rndddmne)
