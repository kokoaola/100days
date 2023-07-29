//
//  CompleteView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI
import UIKit


///ユーザーが当日のタスクを達成したときに表示するコンプリートウインドウ
struct CompleteWindowView: View {
    ///ViewModel用の変数
    @EnvironmentObject var userSettingViewModel:UserSettingViewModel
    @EnvironmentObject var coreDataViewModel :CoreDataViewModel
    
    ///メモ追加シート表示用のフラグ
    @State var showMemo = false
    
    ///画面戻る用のフラグ
    @Binding var showCompleteWindew:Bool
    
    ///画面戻る用のフラグ
    @Binding var closed:Bool
    
    ///実績取り消し押下後の確認アラート用のフラグ
    @State var showCansel = false
    
    ///表示＆共有用の画像
    @State var image: Image?
    
    ///今日が何日目か計算する変数
    let dayNumber: Int
    
    
    ///キーボードフォーカス用変数（Doneボタン表示のため）
//    @FocusState var isInputActive: Bool
    
    
    var body: some View {
        
        //四角に画像とボタンを重ねてる
        VStack(alignment: .leading, spacing: 20){
            
            //閉じるボタン
            Button(action: {
                closed = true
                showCompleteWindew = false
            }){
                CloseButton()
            }
            
            
            VStack(alignment: .center, spacing: 30){
                //読み上げ用のVStack
                VStack{
                    Text("\(dayNumber)日目のチャレンジ達成！")
                    Text("よく頑張ったね！")
                }
                .foregroundColor(.primary)
                .contentShape(Rectangle())
                .accessibilityElement(children: .combine)
                
                
                //コンプリート画像
                generateImageWithText(number: dayNumber, day: coreDataViewModel.allData.last?.date ?? Date.now)
                    .resizable().scaledToFit()
                    .accessibilityLabel("日付入りの画像")
                
                
                VStack{
                    //シェアボタン
                    ShareLink(item: image ?? Image("noImage") , preview: SharePreview("画像", image:image ?? Image("noImage"))){
                        LeftIconBigButton(icon: Image(systemName: "square.and.arrow.up"), text: "シェアする")
                            .foregroundColor(.blue.opacity(0.9))
                    }
                    
                    //メモ追加ボタン
                    Button {
                        showMemo = true
                    } label: {
                        LeftIconBigButton(icon: Image(systemName: "rectangle.and.pencil.and.ellipsis"), text: "メモを追加")
                            .foregroundColor(.green.opacity(0.9))
                    }
                }.padding(30)
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(15)
        
        //メモ追加ボタンが押下されたら、MemoSheetを表示
        .sheet(isPresented: $showMemo) {
            MemoSheet()
                .environmentObject(userSettingViewModel)
        }
    }
}



//struct CompleteDoneView_Previews: PreviewProvider {
//    @State static var aa = false
//    static var previews: some View {
//        Group{
//            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"), dayNumber: 1)
//                .environment(\.locale, Locale(identifier:"en"))
//            CompleteWindowView(showCompleteWindew: $aa, image: Image("noImage"), dayNumber: 1)
//                .environment(\.locale, Locale(identifier:"ja"))
//        }.environmentObject(CoreDataViewModel())
//    }
//}
