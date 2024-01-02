//
//  SettingView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/02/15.
//

import SwiftUI
import UserNotifications


///設定画面のビュー
struct SettingView: View {
    ///ViewModel用の変数
    @EnvironmentObject var globalStore: CoreDataStore
    @ObservedObject var settingViewModel = SettingViewModel()
    
    @ObservedObject var notificationViewModel = NotificationViewModel()
//    @ObservedObject var coreDataViewModel = CoreDataViewModel()
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                
                VStack(spacing: 50) {
                    List{
                        
                        //アプリ全体の色を変更するセル
                        Section(){
                            ///背景色変更用ピッカー
                            Picker(selection: $settingViewModel.userSelectedColor) {
                                Text("青").tag(0)
                                Text("オレンジ").tag(1)
                                Text("紫").tag(2)
                                Text("モノトーン").tag(3)
                            } label: {
                                Text("アプリの色を変更する")
                            }
                            //ピッカーが選択される毎に背景色を変更
                            .onChange(of: settingViewModel.userSelectedColor) { newColor in
                                globalStore.saveSettingColor(newColor)
                            }
                            
                            
                            ///トップ画面の目標を非表示にするスイッチ
                            Toggle("目標を隠す", isOn: $settingViewModel.hideInfomation)
                                .tint(.green)
                                .accessibilityHint("トップ画面の目標を非表示にします")
                            //設定を保存
                                .onChange(of: settingViewModel.hideInfomation) { newSetting in
                                    globalStore.switchHideInfomation(settingViewModel.hideInfomation)
                                }
                            
                            NavigationLink {
                                NotificationView(showToast: $settingViewModel.showToast, toastText: $settingViewModel.toastText)
                            } label: {
                                Text("通知を設定する")
                            }
                        }
                        
                        Section{
                            //長期目標変更用のセル
                            Button("目標を変更する") {
                                settingViewModel.isLongTermGoal = true
                                settingViewModel.showToast = false
                                withAnimation {
                                    settingViewModel.showGoalEdittingAlert = true
                                }
                            }
                            
                            //短期目標変更用のセル
                            Button("100日取り組む内容を変更する") {
                                settingViewModel.isLongTermGoal = false
                                settingViewModel.showToast = false
                                withAnimation {
                                    settingViewModel.showGoalEdittingAlert = true
                                }
                            }
                        }
                        
                        Section{
                            //バックアップデータ取得用のセル
                            NavigationLink {
                                BackUpView()
                            } label: {
                                Text("バックアップ")
                            }
                            
                            //プライバシーポリシーページ遷移用のセル
                            NavigationLink {
                                PrivacyPolicyWebView()
                            } label: {
                                Text("プライバシーポリシー")
                            }
                            
                            //アプリ解説ページ遷移用のセル
                            NavigationLink {
                                AboutThisApp()
                            } label: {
                                Text("このアプリについて")
                            }
                            
                            //お問い合わせページ遷移用のセル
                            NavigationLink {
                                ContactWebView()
                            } label: {
                                Text("お問い合わせ")
                            }
                        }
                        
                        //全データ消去用のセル
                        Section{
                            HStack{
                                Spacer()
                                Text("リセット")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                settingViewModel.showResetAlert = true
                            }
                        }
                    }
                    //アラート表示中はリスト無効、背景透ける
                    .disabled(settingViewModel.showGoalEdittingAlert)
                    .accessibilityHidden(settingViewModel.showGoalEdittingAlert)
                    .opacity(settingViewModel.showGoalEdittingAlert ? 0.3 : 1.0)
                    .animation(nil, value: settingViewModel.showGoalEdittingAlert)
                    .foregroundColor(Color(UIColor.label))
                }
                
                //ナビゲーションの設定
                .navigationTitle("設定")
                .navigationBarTitleDisplayMode(.inline)
                .navigationViewStyle(.stack)
                .scrollContentBackground(.hidden)
                //背景グラデーション設定
                .modifier(UserSettingGradient(appColorNum: settingViewModel.userSelectedColor))
                
                //目標編集セルタップ後に出現するテキストフィールド付きアラート
                if settingViewModel.showGoalEdittingAlert{
                    EditGoal(showAlert: $settingViewModel.showGoalEdittingAlert,showToast: $settingViewModel.showToast,toastText: $settingViewModel.toastText, isLong: settingViewModel.isLongTermGoal)
                        .transition(.opacity)
                }
                
                    
                //完了時に表示されるトーストポップアップ
                ToastView(show: $settingViewModel.showToast, text: settingViewModel.toastText)
            }
            .environmentObject(notificationViewModel)
            .environmentObject(globalStore)
        }
        //アニメーションの設定
        .animation(settingViewModel.showGoalEdittingAlert ? .easeInOut(duration: 0.05) : nil, value: settingViewModel.showGoalEdittingAlert)
        
        //リセットボタン押下時のアラート
        .alert("リセットしますか？", isPresented: $settingViewModel.showResetAlert){
            Button("リセットする",role: .destructive){
                notificationViewModel.resetNotification()
                //                store.resetUserSetting()
                globalStore.deleteAllData()
            }
            Button("戻る",role: .cancel){}
        }message: {
            Text("この動作は取り消せません。")
        }
    }
}




//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group{
//            SettingView()
//                .environment(\.locale, Locale(identifier:"en"))
//            
//            SettingView()
//                .environment(\.locale, Locale(identifier:"ja"))
//        }
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(Store())
//        .environmentObject(NotificationViewModel())
//    }
//}
