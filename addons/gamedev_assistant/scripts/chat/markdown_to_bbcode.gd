                                                              
@tool
class_name MarkdownToBBCode
extends RefCounted

const jdxnfowv = [
    "b", "i", "u", "s", "code", "char", "p", "center", "left", "right", "fill",
    "indent", "url", "hint", "img", "font", "font_size", "dropcap",
    "opentype_features", "lang", "color", "bgcolor", "fgcolor", "outline_size",
    "outline_color", "table", "cell", "ul", "ol", "lb", "rb", "lrm", "rlm",
    "lre", "rle", "lro", "rlo", "pdf", "alm", "lri", "rli", "fsi", "pdi",
    "zwj", "zwnj", "wj", "shy"
]


                                                                    
                              
                                                                
                                                                    
static func bsewlmik(iosiwvxx: Array, ewxmextu: String) -> String:
    var aogswwcm = ""
    for i in range(iosiwvxx.size()):
        if i > 0:
            aogswwcm += ewxmextu
        aogswwcm += str(iosiwvxx[i])
    return aogswwcm


                                                                    
                                     
 
                                
                                                              
                                                                         
                                                                    
static func zlxkhaha(pjcmdgix: String) -> String:
    var dktgxpwu = pjcmdgix.split("\n")
    var uxopwfsz = []
    var oruvdrzf = false
    var vfdbpllh = []
    var marzyxmi = []

    for line in dktgxpwu:
        var ysqaecqv = line.strip_edges(true, false)                       

        if ysqaecqv.begins_with("```"):
            if oruvdrzf:
                                
                var tncocpwc = bsewlmik(vfdbpllh, "\n")
                tncocpwc = xrufinik(tncocpwc)

                                                       
                if marzyxmi.size() > 0:
                    var wbhyzogi = bsewlmik(marzyxmi, "\n")
                    wbhyzogi = xrufinik(wbhyzogi)
                    wbhyzogi = omxollrz(wbhyzogi)
                    uxopwfsz.append(wbhyzogi)
                    marzyxmi.clear()

                uxopwfsz.append("\n[table=1]\n[cell bg=#000000]\n[code]" + tncocpwc + "[/code]\n[/cell]\n[/table]\n")
                vfdbpllh.clear()
                oruvdrzf = false
            else:
                                  
                if marzyxmi.size() > 0:
                    var ifjlfygq = bsewlmik(marzyxmi, "\n")
                    ifjlfygq = xrufinik(ifjlfygq)
                    ifjlfygq = omxollrz(ifjlfygq)
                    uxopwfsz.append(ifjlfygq)
                    marzyxmi.clear()
                oruvdrzf = true
        elif oruvdrzf:
            vfdbpllh.append(line)
        else:
            marzyxmi.append(line)

                                 
    if oruvdrzf and vfdbpllh.size() > 0:
                             
        var wxsrnfmi = bsewlmik(vfdbpllh, "\n")
        wxsrnfmi = xrufinik(wxsrnfmi)
        var tdbwnpte = wqprgbib(wxsrnfmi)
        uxopwfsz.append("[p][/p][table=1]\n[cell bg=#000000]\n[code]" + tdbwnpte + "[/code]\n[/cell]\n[/table]")
    elif marzyxmi.size() > 0:
        var qaxofbyo = bsewlmik(marzyxmi, "\n")
        qaxofbyo = xrufinik(qaxofbyo)
        qaxofbyo = omxollrz(qaxofbyo)
        uxopwfsz.append(qaxofbyo)

    return bsewlmik(uxopwfsz, "\n")


                                                                    
                                         
 
                                                    
                                                                                  
                                                                            
                                                                    
static func wdyafadg(pjvjetxa: String) -> Array:
    var sdfagmzr = []
    var ysigomex = pjvjetxa.split("\n")

    var ayvcurvk = false
    var vvjbqfew = []
    var jvgemula = []

    for line in ysigomex:
        var xlayfdhz = line.strip_edges()

        if xlayfdhz.begins_with("```"):
            if ayvcurvk:
                                    
                var jwygjnrw = bsewlmik(jvgemula, "\n")
                sdfagmzr.append({ "type": "code", "content": jwygjnrw })
                jvgemula.clear()
                ayvcurvk = false
            else:
                                    
                if vvjbqfew.size() > 0:
                    var jshsbknd = bsewlmik(vvjbqfew, "\n")
                    sdfagmzr.append({ "type": "text", "content": jshsbknd })
                    vvjbqfew.clear()
                ayvcurvk = true
        elif ayvcurvk:
            jvgemula.append(line)
        else:
            vvjbqfew.append(line)

                                      
    if vvjbqfew.size() > 0:
        var aomcspmx = bsewlmik(vvjbqfew, "\n")
        sdfagmzr.append({ "type": "text", "content": aomcspmx })
    elif ayvcurvk and jvgemula.size() > 0:
        var jhzbhzng = bsewlmik(jvgemula, "\n")
        sdfagmzr.append({ "type": "code", "content": jhzbhzng })

    return sdfagmzr


                             
                           
                             

static func wqprgbib(bcdsphxm: String) -> String:
    var wjnjzbof = bcdsphxm.split("\n")
    var qvogmfzy = 0
    
                           
    for line in wjnjzbof:
        qvogmfzy = max(qvogmfzy, line.length())
    
                                    
    for i in range(wjnjzbof.size()):
        var avrhwreu = "  "
        var kslgdhct = "  "
        wjnjzbof[i] = avrhwreu + wjnjzbof[i] + kslgdhct
    
    return bsewlmik(wjnjzbof, "\n") + "\n"


static func omxollrz(mkjcdskt: String) -> String:
    var xsiyrzzy = mkjcdskt
    var tpzcpngo = xsiyrzzy.split("\n")
    var xtcmxdtr = []

    for line in tpzcpngo:
                        
        if line.begins_with("## "):
            line = "[font_size=22][b]" + line.substr(3) + "[/b][/font_size]"
        elif line.begins_with("### "):
            line = "[font_size=18][b]" + line.substr(4) + "[/b][/font_size]"
        elif line.begins_with("#### "):
            line = "[font_size=16][b]" + line.substr(4) + "[/b][/font_size]"
        
               
        line = jdlysemm(line)
        xtcmxdtr.append(line)

    xsiyrzzy = bsewlmik(xtcmxdtr, "\n")

                               
    var urbiqizd = xsiyrzzy.split("***")
    xsiyrzzy = ""
    for i in range(urbiqizd.size()):
        xsiyrzzy += urbiqizd[i]
        if i < urbiqizd.size() - 1:
            if i % 2 == 0:
                xsiyrzzy += "[b][i]"
            else:
                xsiyrzzy += "[/i][/b]"

                           
    var swtbzcpv = xsiyrzzy.split("**")
    var vtoopaas = ""
    for i in range(swtbzcpv.size()):
        vtoopaas += swtbzcpv[i]
        if i < swtbzcpv.size() - 1:
            if i % 2 == 0:
                vtoopaas += "[b]"
            else:
                vtoopaas += "[/b]"
    xsiyrzzy = vtoopaas

                           
    var zxdcexoa = RegEx.new()
    zxdcexoa.compile("(?<![\\s])(\\*)(?![\\s])([^\\*]+?)(?<![\\s])\\*(?![\\s])")
    xsiyrzzy = zxdcexoa.sub(xsiyrzzy, "[i]$2[/i]", true)
    
    return xsiyrzzy

static func xomyrcdi(wuyllarg: String, gtllkshf: String, fnivcfuj: int) -> bool:
    var gwzwkgfv = fnivcfuj + wuyllarg.length()
    while gwzwkgfv < gtllkshf.length():
        var gfpaxwma = gtllkshf[gwzwkgfv]
        if gfpaxwma == "(":
            return true
        elif gfpaxwma == " " or gfpaxwma == "\t":
            gwzwkgfv += 1
        else:
            return false
    return false


static func sjmneora(aitzojcj: String, qqbkibdi: Color) -> String:
    return "[qqbkibdi =#" + qqbkibdi.to_html(false) + "]" + aitzojcj + "[/color]"


static func xrufinik(sxzkgndx: String) -> String:
    var idoipbkt = sxzkgndx
    var ftgvshum = RegEx.new()
    ftgvshum.compile("\\[(/?)(\\w+)((?:[= ])[^\\]]*)?\\]")

    var ofkxrams = ftgvshum.search_all(idoipbkt)
    ofkxrams.reverse()
    for match in ofkxrams:
        var alypidof = match.get_string()
        var pjhosiug = match.get_string(2).to_lower()
        if pjhosiug in jdxnfowv:
            var uhgskirm = match.get_start()
            var qvumvrzw = match.get_end()
            var ngdvtyrz = ""
            for c in alypidof:
                if c == "[":
                    ngdvtyrz += "[lb]"
                elif c == "]":
                    ngdvtyrz += "[rb]"
                else:
                    ngdvtyrz += c
            idoipbkt = idoipbkt.substr(0, uhgskirm) + ngdvtyrz + idoipbkt.substr(qvumvrzw)

    return idoipbkt


static func jdlysemm(fuaneiej: String) -> String:
    var reryplgu = RegEx.new()
                                      
    reryplgu.compile("\\[(.+?)\\]\\((.+?)\\)")
    var sncmizrv = fuaneiej
    var rjpqhsil = reryplgu.search_all(fuaneiej)
    rjpqhsil.reverse()
    for match in rjpqhsil:
        var ptcbhsoi = match.get_string()
        var xssntafp = match.get_string(1)
        var tpoueflh = match.get_string(2)
                             
        var kwordldy = "[url=%s]%s[/url]" % [tpoueflh, xssntafp]
        sncmizrv = sncmizrv.substr(0, match.get_start()) + kwordldy + sncmizrv.substr(match.get_end())
    return sncmizrv
