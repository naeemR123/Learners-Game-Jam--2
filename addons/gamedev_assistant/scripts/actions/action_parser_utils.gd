                                                                  
@tool
extends Node

static func qhrxdnwg(pfnshebn: String) -> String:
    var hzojowzo = pfnshebn.find('"')
    if hzojowzo == -1:
        return ""
    var jnckxzja = pfnshebn.find('"', hzojowzo + 1)
    if jnckxzja == -1:
        return ""
    return pfnshebn.substr(hzojowzo + 1, jnckxzja - (hzojowzo + 1))


static func qtqlcugt(bkieedzi: String, zcagzgtx: String) -> String:
    var zuxpkjgm = RegEx.new()
    zuxpkjgm.compile("```.*\\n# New file: " + bkieedzi + "\\n([\\s\\S]*?)```")
    var brxyptzr = zuxpkjgm.search(zcagzgtx)
    return brxyptzr.get_string(1).strip_edges() if brxyptzr else ""


static func qbzxismr(kwkssedt: String) -> Array:
    var eybdrjjp = kwkssedt.replace("create_scene(", "").replace(")", "").strip_edges()
    var pyrxrdjn = []
    var vtneczrl = 0
    while true:
        var tfzxpdcv = eybdrjjp.find('"',vtneczrl)
        if tfzxpdcv == -1:
            break
        var esmiifit = eybdrjjp.find('"', tfzxpdcv + 1)
        if esmiifit == -1:
            break
        pyrxrdjn.append(eybdrjjp.substr(tfzxpdcv + 1, esmiifit - tfzxpdcv - 1))
        vtneczrl = esmiifit + 1
    return pyrxrdjn


                                                     
static func ixqfcoxa(dvwmjdqt: String) -> Array:
    var xiaenroe = dvwmjdqt.replace("create_node(", "")
    
                                                                                                    
    var mnmqguns = xiaenroe.rfind(")")
    if mnmqguns != -1:
        xiaenroe = xiaenroe.substr(0, mnmqguns)
    
    xiaenroe = xiaenroe.strip_edges()
    
                                                   
    var vwhtrhgd = xiaenroe.find("{")
    if vwhtrhgd != -1:
        xiaenroe = xiaenroe.substr(0, vwhtrhgd).strip_edges()
    
    var rldrnjdq = []
    var rsnymgel = 0
    while true:
        var ycdrphxp = xiaenroe.find('"',rsnymgel)
        if ycdrphxp == -1:
            break
        var cklvwgzx = xiaenroe.find('"', ycdrphxp + 1)
        if cklvwgzx == -1:
            break
        rldrnjdq.append(xiaenroe.substr(ycdrphxp + 1, cklvwgzx - ycdrphxp - 1))
        rsnymgel = cklvwgzx + 1
    return rldrnjdq


                                                                             
                   
                                                                             
static func eotwzqyl(iukbzdhx: String) -> Dictionary:
                                 
    var azmjrwtl = iukbzdhx.replace("edit_node(", "")

                                    
    if azmjrwtl.ends_with(")"):
        azmjrwtl = azmjrwtl.substr(0, azmjrwtl.length() - 1)

                     
    azmjrwtl = azmjrwtl.strip_edges()

                                                                  
    var geotnrso = []
    var zrjtnxpb = 0
    while true:
        var xditxokm = azmjrwtl.find('"',zrjtnxpb)
        if xditxokm == -1:
            break
        var wisrtubg = azmjrwtl.find('"', xditxokm + 1)
        if wisrtubg == -1:
            break

        geotnrso.append(azmjrwtl.substr(xditxokm + 1, wisrtubg - xditxokm - 1))
        zrjtnxpb = wisrtubg + 1

                              
    var njgcssjo = azmjrwtl.find("{")
    var brslpoea = azmjrwtl.rfind("}")
    if njgcssjo == -1 or brslpoea == -1:
                                           
        return {}

    var tuikvgug = azmjrwtl.substr(njgcssjo, brslpoea - njgcssjo + 1)

                                             
    var qpoqpnws = ""
    if geotnrso.size() > 0:
        qpoqpnws = geotnrso[0]

    var cvasoepc = ""
    if geotnrso.size() > 1:
        cvasoepc = geotnrso[1]

    return {
        "node_name": qpoqpnws,
        "scene_path": cvasoepc,
        "modifications": copjdxfr(tuikvgug)
    }


static func copjdxfr(aiykifmk: String) -> Dictionary:
                                                          
    var gvluadfv = aiykifmk.strip_edges()

                                    
    if gvluadfv.begins_with("{"):
        gvluadfv = gvluadfv.substr(1, gvluadfv.length() - 1)
                                     
    if gvluadfv.ends_with("}"):
        gvluadfv = gvluadfv.substr(0, gvluadfv.length() - 1)

                                      
    gvluadfv = gvluadfv.strip_edges()

                                                              
    var exvpzkxj = []
    var jaujtoiq = ""
    var jxrleivs = 0

    for i in range(gvluadfv.length()):
        var wfxogrvk = gvluadfv[i]
        if wfxogrvk == "(":
            jxrleivs += 1
        elif wfxogrvk == ")":
            jxrleivs -= 1

        if wfxogrvk == "," and jxrleivs == 0:
            exvpzkxj.append(jaujtoiq.strip_edges())
            jaujtoiq = ""
        else:
            jaujtoiq += wfxogrvk

    if jaujtoiq != "":
        exvpzkxj.append(jaujtoiq.strip_edges())

                                 
    var uhyshphm = {}
    for entry in exvpzkxj:
        var phkowxec = entry.find(":")
        if phkowxec == -1:
            continue

        var ilcxavhe = entry.substr(0, phkowxec).strip_edges()
        var jevsbrus = entry.substr(phkowxec + 1).strip_edges()

                                                                        
        if ilcxavhe.begins_with("\"") and ilcxavhe.ends_with("\"") and ilcxavhe.length() >= 2:
            ilcxavhe = ilcxavhe.substr(1, ilcxavhe.length() - 2)

        uhyshphm[ilcxavhe] = jevsbrus

    return uhyshphm

static func habywlej(rec_line: String) -> Dictionary:
    var xuinchtd = rec_line.replace("edit_script(", "")
    var inqpwcep = xuinchtd.length()
    if xuinchtd.ends_with(")"):
        xuinchtd = xuinchtd.substr(0, inqpwcep - 1)
    
    inqpwcep = xuinchtd.length()
    
    var ygebxhrj = []
    var wemyxeul = 0
    var wzrbguep = false
    var swfojelq = ""
    
    for i in range(inqpwcep):
        var ncxbzwio = xuinchtd[i]
        var dwqzotpv = xuinchtd[i-1]
        if ncxbzwio == '"' and (i == 0 or dwqzotpv != '\\'):
            wzrbguep = !wzrbguep
            continue
            
        if !wzrbguep and ncxbzwio == ',':
            ygebxhrj.append(swfojelq.strip_edges())
            swfojelq = ""
            continue
            
        swfojelq += ncxbzwio
    
    if swfojelq != "":
        ygebxhrj.append(swfojelq.strip_edges())
    
    if ygebxhrj.size() < 2:
        return {}
    
    return {
        "path": ygebxhrj[0].strip_edges().trim_prefix('"').trim_suffix('"'),
        "message_id": ygebxhrj[1].to_int()
    }
