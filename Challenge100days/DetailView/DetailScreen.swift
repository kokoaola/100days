//
//  MemoView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/04.
//

import SwiftUI
import CoreData


///記録の詳細を表示するビュー
struct DetailScreen: View {
    ///ViewModel用の変数
    @EnvironmentObject var coreDataStore: CoreDataStore
    @StateObject var detailVM = DetailViewModel()
    @EnvironmentObject var notificationVM: NotificationViewModel
    
    ///ビュー生成時にオブジェクトデータ受け取る用変数
    let item: DailyData
    
    ///シェア用の画像格納用変数
    @State private var image: Image?
    
    @Binding var allData: [DailyData]
    
    // 配列を更新するクロージャを受け取るプロパティ
    var onDeleted: ([DailyData]) -> Void
    
    ///画面破棄用の変数
    @Environment(\.dismiss) var dismiss
    ///キーボードフォーカス用変数（Doneボタン表示のため）
    @FocusState var isInputActive: Bool
    
    var body: some View {
        
        VStack{
            //100日のうち何日目＋記録の日付を横並びで表示
            HStack{
                Text("\(item.num ) / 100")
                    .font(.title)
                
                Spacer()
                
                Text(AppSetting.makeDate(day: item.wrappedDate))
                    .font(.title3.weight(.ultraLight))
                    .padding(.leading, 40)
            }
            .accessibilityElement()
            .accessibilityLabel("\(item.num)日目の記録、\(AppSetting.makeAccessibilityDate(day: item.wrappedDate))")
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .onTapGesture {
                isInputActive.toggle()
            }
            
            //メモが何も記入されていない場合はプレースホルダーを表示
            ZStack(alignment: .topLeading){
                if detailVM.editText.isEmpty && !isInputActive{
                    Text("保存されたメモはありません。\nタップで追加できます。")
                        .foregroundColor(.primary.opacity(0.4))
                }
                //メモ編集用のテキストエディター
                TextEditor(text: $detailVM.editText)
                    .customDetailViewTextEditStyle()
                    .focused($isInputActive)
                //タップでキーボードを閉じる
                    .onTapGesture {
                        isInputActive.toggle()
                    }
            }
        }
        .detailViewStyle()
        //グラデーション背景の設定
        .modifier(UserSettingGradient())
        
        
        .onAppear{
            detailVM.setItem(item: item)
            //あらかじめシェア用の画像を生成
            DispatchQueue.main.async {
                image = generateImageWithText(number: Int(item.num), day: item.wrappedDate)
            }
            
            //保存されたメモ内容があれば、テキストエディターの初期値として表示
            detailVM.editText = item.wrappedMemo
        }
        
        
        .toolbar{
            //保存ボタンを配置
            ToolbarItemGroup(placement: .keyboard) {
                
                //文字数が上限を超えてる時の注意書き
                Text("\(AppSetting.maxLengthOfMemo)文字以内のみ設定可能です")
                    .font(.caption)
                    .foregroundColor(detailVM.isTextValid ? .clear : .red)
                
                //編集内容保存ボタン
                Button("保存する") {
                    detailVM.updateMemo(item: item)
                    isInputActive = false
                    coreDataStore.setAllData()
                }
                
                .foregroundColor(detailVM.isTextValid ? .primary : .gray)
                .opacity(detailVM.isTextValid ? 1.0 : 0.5)
                .disabled(!detailVM.isTextValid)
            }
            
            //表示している日の記録の削除用ごみ箱アイコン
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    detailVM.showCansel = true
                } label: {
                    Image(systemName: "trash")
                }
                .foregroundColor(.red)
                .padding(.trailing)
            }
            
            //画像シェア用のリンク
            ToolbarItem(placement: .navigationBarTrailing) {
                // MARK: -
                ShareLink(item: image ?? Image("noImage") , preview: SharePreview("Image", image:image ?? Image("noImage") )){
                    Image(systemName: "square.and.arrow.up")
                    
                }
            }
            
            //戻るボタン
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack{
                        Image(systemName: "chevron.backward")
                        Text("戻る")
                    }
                }
            }
        }
        .foregroundColor(Color(UIColor.label))
        
        
        //削除ボタン押下時のアラート
        .alert("この日の記録を破棄しますか？", isPresented: $detailVM.showCansel){
            Button("破棄する",role: .destructive){
                dismiss()
                
                //アイテムを削除
                detailVM.deleteData(data: item) {
                    //通知の更新
                    Task{
                        await coreDataStore.assignNumbers(completion: {
                            withAnimation {
                                //CardAndListViewに削除後の配列をセットし直す処理を実行
                                onDeleted(coreDataStore.allData)
                            }
                        })
                        
                        //削除したデータと本日の日付が同じなら、通知は本日分をスキップして再セット
                        let deletedData = Calendar.current.dateComponents([.year, .month, .day], from: item.wrappedDate)
                        let today = Calendar.current.dateComponents([.year, .month, .day], from: Date())
                        if deletedData == today{
                            await notificationVM.setNotification(isFinishTodaysTask: true, time: nil, days: nil)
                        }
                    }
                }
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("表示中のデータは破棄されます。\n（この動作は取り消せません。）")
        }
        
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}


//struct MemoView_Previews: PreviewProvider {
//    static private var dataController = PersistenceController.persistentContainer.viewContext
//    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//
//    static var previews: some View {
//
//        DetailScreen(item:DailyData(context: dataController))
//        //            MemoView(num: 1, item: book)
//            .environment(\.managedObjectContext, PersistenceController.persistentContainer.viewContext)
//
//    }
//}
//
