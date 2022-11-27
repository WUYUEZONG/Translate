//
//  ContentView.swift
//  Translate
//
//  Created by mntechMac on 2022/11/16.
//

import SwiftUI
import WZRequestTool

struct MenuItem: View {
    var isSeleted: Bool = false
    var model: TransLangModel
    var body: some View {
        HStack {
            if (isSeleted) {
                Image(systemName: "checkmark")
            }
            Text(model.name)
        }
    }
}

struct ContentView: View {
    
    @State var editingText: String = "hello"

    @State var translateReusltText: String = ""
    
    /// 将要被翻译的语言
    @State var translateLangs: [TransLangModel] = [.en, .zh]
    
    @State private var translateFrom: TransLangModel = .auto
    
    let allTranslateLangs: [TransLangModel] = TransLangModel.languages
    
    func addTransLangIfNeeded(lang: TransLangModel) -> Void {
        let isContains = translateLangs.contains { l in
            return l.id == lang.id
        }
        if (!isContains) {
            translateLangs.append(lang)
        } else {
            translateLangs.removeAll { l in
                return l.id == lang.id
            }
        }
    }
    
    mutating func setTranslateFrome(lang: TransLangModel) -> Void {
        translateFrom = lang
    }
    
    func reqeust(q: String, to: TransLangModel) {
        WZRequestTool<TransRequests, [String: Any]>.request(target: .vipTranslate(q: q, from: translateFrom.keyCode, to: to.keyCode)) { data in
            debugPrint(data)
            guard let trans_results = data["trans_result"] as? [[String: Any]] else { return }
            guard let first = trans_results.first, let dst = first["dst"] as? String else { return }
            translateReusltText = dst
        } fail: { error in
            
        }

    }
    
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("输入并选择需要翻译的文本")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Spacer()
                    Menu(translateFrom.name) {
                        
                        ForEach(TransLangModel.languagesWithAuto) { lang in
                            
                            Button {
                                self.translateFrom = lang
                            } label: {
                                MenuItem(isSeleted: false, model: lang)
                                
                            }
                        }
                    }
                    .frame(width: 90)
                }
                
                TextEditor(text: $editingText)
                    .frame(minHeight: 80, idealHeight: 120, maxHeight: 140)
                    .onChange(of: editingText, perform: { newValue in
                        debugPrint(editingText)
                        if (editingText.isEmpty) {

                        }
//                        reqeust(q:editingText, to: translateLangs.first!)

                    })
                    
                    .onSubmit {
                        debugPrint("onsubmit",editingText)
                    }

                    .font(.body)
                
                
                    
                    
                
            }
            VStack {
                HStack {
                    
                    ForEach(translateLangs) { Lang in
                        Button(Lang.name) {
                            reqeust(q:editingText, to: Lang)
                        }
                    }
                    
                    Spacer()
                    Menu("语言") {
                        
                        ForEach(allTranslateLangs) { lang in
                            
                            Button {
                                addTransLangIfNeeded(lang: lang)
                            } label: {
                                
                                let isSeleted = translateLangs.contains { l in
                                    l.id == lang.id
                                }
                                
                                MenuItem(isSeleted: isSeleted, model: lang)
                                
                            }
                        }
                    }
                    .frame(width: 90)
                }
                HStack {
                    Text(translateReusltText)
                        .multilineTextAlignment(.leading)
                        .frame( minHeight: 30)
                        .textSelection(.enabled)
                        .padding()
                    
                    Spacer()
                }
                
            }
            Spacer()
            
        }
        .frame(width: 360)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {

    static var previews: some View {
        ContentView()
    }
}
