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
    
    @State var editingText: String = ""
    @State var translateText: String = ""
    
    @State var translateLangs: [TransLangModel] = []
    
    let allTranslateLangs: [TransLangModel] = [
        TransLangModel(name: "cn"),
        TransLangModel(name: "en"),
        TransLangModel(name: "222222"),
        TransLangModel(name: "3333"),
        TransLangModel(name: "433"),
        TransLangModel(name: "54434343"),
        TransLangModel(name: "544343431"),
    ]
    
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
    
    func reqeust(q: String) {
        WZRequestTool<TransRequests, [String: Any]>.request(target: .vipTranslate(q: q, to: "zh")) { data in
            
        } fail: { error in
            
        }

    }
    
    
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Text("输入需要翻译的文本")
                        .font(.footnote)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
                
                TextEditor(text: $editingText)
                    .frame(minHeight: 130, idealHeight: 140, maxHeight: 150)
                    .onChange(of: editingText, perform: { newValue in
                        
                        if (editingText.isEmpty) {
                            
                        }
                    })
                    .onSubmit {
                        translateText = editingText
                    }
                    .font(.body)
                
            }
            
                
            
            VStack {
//                HStack {
//                    Text("添加翻译语言")
//                        .font(.footnote)
//                        .foregroundColor(Color.gray)
//                    Spacer()
//                }
                HStack {
                    
                    ForEach(translateLangs) { Lang in
                        Button(Lang.name) {
//                            translateText = Lang.name
                            reqeust(q: translateText)
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
                    .frame(width: 80)
                }
                Text(translateText)
                    .frame(minHeight: 30)
            }
            
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
