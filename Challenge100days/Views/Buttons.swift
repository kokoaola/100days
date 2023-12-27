//
//  OriginalButton.swift
//  timer
//
//  Created by koala panda on 2023/01/20.
//

import SwiftUI


///シート等の閉じるボタンのビュー
struct CloseButton: View{
    var body: some View {
        Text("閉じる")
//        Image(systemName: "xmark")
            .foregroundColor(.blue)
            .padding()
    }
}


///チュートリアル用の矢印付きボタンのビュー
struct ArrowButton: View{
    ///戻るボタンか選択する変数
    var isBackButton: Bool
    ///表示する文言を格納する変数
    var labelText: String
    
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    
    ///ボタンの幅を格納する変数
    let width = AppSetting.screenWidth / 3
    
    ///ボタンの高さを格納する変数
    let height = AppSetting.screenWidth / 6
    
    ///文字色を格納する変数
    let tint = Color.white
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                if isBackButton{
                    Image(systemName: "arrowshape.left")
                    Text(LocalizedStringKey(labelText))
                }else{
                    Text(LocalizedStringKey(labelText))
                    Image(systemName: "arrowshape.right")
                }
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
        .foregroundColor( isBackButton ? .orange : .green)
    }
}


///保存ボタンビュー
struct SaveButton: View {
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    
    ///ボタンの幅を格納する変数
    let width = AppSetting.screenWidth / 3
    
    ///ボタンの高さを格納する変数
    let height = AppSetting.screenWidth / 6
    
    ///文字色を格納する変数
    let tint = Color.white
    
    var body: some View {
        ZStack(alignment: .center){
            
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
            
            HStack(alignment: .firstTextBaseline, spacing: 5){
                Text("保存する")
                Image(systemName: "checkmark.circle")
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
    }
}


///アイコンが左にある大きいボタンのビュー
struct LeftIconBigButton: View{
    let color: Color
    ///アイコンを受け取って格納する変数
    let icon: Image?
    
    ///表示するStringを受け取って格納する変数
    let text: String
    
    ///角丸のレベルを格納する変数
    let radius:CGFloat = 10.0
    
    ///ボタンの幅を格納する変数
    let width = UIDevice.current.userInterfaceIdiom == .pad ? AppSetting.screenWidth / 3 : AppSetting.screenWidth / 1.7
    
    ///ボタンの高さを格納する変数
    let height = AppSetting.screenWidth / 5
    
    ///文字色を格納する変数
    let tint = Color(UIColor.white)
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width, height: height)
                .foregroundColor(tint)
            RoundedRectangle(cornerRadius: radius)
                .frame(width: width - 7, height: height - 7)
            HStack(alignment: .lastTextBaseline){
                icon
                Text(LocalizedStringKey(text))
            }
            .font(.title2.weight(.bold))
            .foregroundColor(tint)
        }
        .foregroundColor(color.opacity(0.9))
    }
}




struct OriginalButton_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            
            VStack{
                LeftIconBigButton(color:.blue, icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                
                CloseButton()
                HStack{
                    ArrowButton(isBackButton: true, labelText: "戻る")
                    ArrowButton(isBackButton: false, labelText: "次へ")
                }
                SaveButton()
                CompleteButton(num: 1)
            }
            .environment(\.locale, Locale(identifier:"en"))
            
            VStack{
                CloseButton()
                HStack{
                    ArrowButton(isBackButton: true, labelText: "戻る")
                    ArrowButton(isBackButton: false, labelText: "次へ")
                }
                SaveButton()
                CompleteButton(num: 1)
            }
            .environment(\.locale, Locale(identifier:"ja"))
        }
    }
}
