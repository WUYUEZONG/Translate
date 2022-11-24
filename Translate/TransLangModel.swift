//
//  TransLangModel.swift
//  Translate
//
//  Created by mntechMac on 2022/11/16.
//

import SwiftUI
import WZRequestTool
import Alamofire
import CommonCrypto

struct TransLangModel: Identifiable {

    let keyCode: String
    let name: String
    var id: String { keyCode }
    
}

extension TransLangModel {
    static var auto: TransLangModel = {
        return TransLangModel(keyCode: "auto", name: "自动检测")
    }()
    
    static var zh: TransLangModel = {
        return TransLangModel(keyCode: "zh", name: "中文")
    }()
    
    static var en: TransLangModel = {
        return TransLangModel(keyCode: "en", name: "英语")
    }()
    
    static var yue: TransLangModel = {
        return TransLangModel(keyCode: "yue", name: "粤语")
    }()
    
    static var wyw: TransLangModel = {
        return TransLangModel(keyCode: "wyw", name: "文言文")
    }()
    
    static var jp: TransLangModel = {
        return TransLangModel(keyCode: "jp", name: "日语")
    }()
    
    static var kor: TransLangModel = {
        return TransLangModel(keyCode: "kor", name: "韩语")
    }()
    
    static var fra: TransLangModel = {
        return TransLangModel(keyCode: "fra", name: "法语")
    }()
    
    static var spa: TransLangModel = {
        return TransLangModel(keyCode: "spa", name: "西班牙语")
    }()
    
    static var th: TransLangModel = {
        return TransLangModel(keyCode: "th", name: "泰语")
    }()
    
    static var ara: TransLangModel = {
        return TransLangModel(keyCode: "ara", name: "阿拉伯语")
    }()
    
    static var ru: TransLangModel = {
        return TransLangModel(keyCode: "ru", name: "俄语")
    }()
    
    static var pt: TransLangModel = {
        return TransLangModel(keyCode: "pt", name: "葡萄牙语")
    }()
    
    static var de: TransLangModel = {
        return TransLangModel(keyCode: "de", name: "德语")
    }()
    
    static var it: TransLangModel = {
        return TransLangModel(keyCode: "it", name: "意大利语")
    }()
    
    static var el: TransLangModel = {
        return TransLangModel(keyCode: "el", name: "希腊语")
    }()
    
    static var nl: TransLangModel = {
        return TransLangModel(keyCode: "nl", name: "荷兰语")
    }()
    
    
    static var pl: TransLangModel = {
        return TransLangModel(keyCode: "pl", name: "波兰语")
    }()
    
    static var bul: TransLangModel = {
        return TransLangModel(keyCode: "bul", name: "保加利亚语")
    }()
    
    static var est: TransLangModel = {
        return TransLangModel(keyCode: "est", name: "爱沙尼亚语")
    }()
    
    
}

extension TransLangModel {
    
    ///
    static var languages: [TransLangModel] {
        return [
            .auto,
            .zh,
            .en,
            .yue,
            .wyw,
            .jp,
            .kor,
            .fra,
            .spa,
            .th,
            .ara,
            .ru,
            .pt,
            .de,
            .it,
            .el,
            .nl,
            .pl,
            .bul,
            .est,
        ]
    }
}



enum TransRequests: WZRequestDelegate {
    
    /// https://fanyi-api.baidu.com/api/trans/vip/translate
    case vipTranslate(q: String, from: String = "auto", to: String)
}

extension TransRequests  {
    
    
    var request: (base: String, path: String, method: Alamofire.HTTPMethod, header: [String : String], params: [String : Any]?, encoding: Alamofire.ParameterEncoding) {
        var path = ""
        var method: HTTPMethod = .get
        var header = ["Content-Type": "application/json"]
        var params: [String: Any]? = nil
        let encoding: ParameterEncoding = URLEncoding.default
        switch self {
        case let .vipTranslate(q, from, to):
            
            let randomNum = "1435660288"
            let appid = "20210527000845004"
            let md5 = "\(appid)\(q)\(randomNum)rsUpZZ57xQOgoykrZpOS".md5
            
            method = .post
            params = [
                "q": q,
                "from":from,
                "to": to,
                "appid": appid,
                "salt": randomNum,
                "sign": md5
            ]
            
            path = "/api/trans/vip/translate"
            header = ["Content-Type": "application/x-www-form-urlencoded"]
            
        }
        return ("https://fanyi-api.baidu.com", path, method, header, params, encoding)
        
    }
    
    
}

extension String {
    /* ################################################################## */
    /**
     - returns: the String, as an MD5 hash.
     */
    var md5: String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)

        let hash = NSMutableString()

        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }

        result.deallocate()
        return hash as String
    }
}
