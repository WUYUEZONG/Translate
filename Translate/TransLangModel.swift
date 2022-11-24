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

    
    let name: String
    var id: String { name }
    
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
            
            let randomNum = "1"
            let appid = "20210527000845004"
            let md5 = "\(q)\(appid)\(randomNum)rsUpZZ57xQOgoykrZpOS".md5
            
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
