//
//  Notification.swift
//  Challenge100days
//
//  Created by koala panda on 2023/07/16.
//

import SwiftUI
import UserNotifications
import UserNotifications


struct NotificationView: View {
    @EnvironmentObject var vm :ViewModel
    
    ///CoreData用の変数
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var items: FetchedResults<DailyData>
    ///画面破棄用
    @Environment(\.dismiss) var dismiss
    let week = [1,2,3,4,5,6,7]

    
    var body: some View {
        
        VStack{
            DatePicker("", selection: $vm.userSettingNotificationTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 150)
            
            List(selection: $vm.userSettingNotificationDay){
                Section(header: Text("通知を出す曜日")){
                    ForEach(week, id: \.self) { item in
                        Text("\(numToDate(num:item))")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .environment(\.editMode, .constant(.active))
            .tint(.green)
            
            
            Button {
                vm.setNotification(items: items)
                    dismiss()
            } label: {
                okButton()
                    .foregroundColor(.green)
                    .padding(.bottom)
            }
        }

    }
    
    
//    func setNotification(time:Date, days: Set<Int>){
//
////        print(vm.checkTodaysTask(items: days))
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//        vm.saveUserSelectedTime(time: time)
//        vm.saveUserSelectedDays(day: days)
//
//        let content = UNMutableNotificationContent()
//
//
//
//        content.sound = UNNotificationSound.default
//        content.title = "今日のタスクを達成させよう"
////        content.subtitle = "100日チャレンジ継続中"
//        content.body = "100日チャレンジ継続中！"
//
//
//        // 通知時刻を指定
//        //        var component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: time)
//        let component = Calendar.current.dateComponents([.hour, .minute], from: time)
//
//
//        var setDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
//
//        //今日のタスク完了済みなら明日から
//        if vm.checkTodaysTask(items: items){
//            setDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date().addingTimeInterval(24*60*60))
//        }
//
//
//        var dateComponentsDay = DateComponents()
//        dateComponentsDay.year = setDate.year
//        dateComponentsDay.month = setDate.month
//        dateComponentsDay.day = setDate.day
//        dateComponentsDay.hour = component.hour
//        dateComponentsDay.minute = component.minute
//
//        var notificationRequests = [UNNotificationRequest]()
//
//        // リクエストを作成
//        for day in days{
//            dateComponentsDay.weekday = day  // 1が日曜日、2が月曜日、というように設定
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponentsDay, repeats: true)
//            // リクエストを作成
//            let uuidStringMonday = UUID().uuidString
//            let request = UNNotificationRequest(identifier: uuidStringMonday,content: content, trigger: trigger)
//            notificationRequests.append(request)
//        }
//
//        let notificationCenter = UNUserNotificationCenter.current()
//
//        for notificationRequest in notificationRequests {
//            // ローカル通知をスケジュール
//            notificationCenter.add(notificationRequest) { (error) in
//                if let error = error {
//                    print("Error \(error.localizedDescription)")
//                }
//            }
//        }
//
//        // 通知リクエストを登録
////        UNUserNotificationCenter.current().add(request){ (error : Error?) in
////            if let error = error {
////                print(error.localizedDescription)
////            }
////        }
//        //        //1コンテンツ   表示されるべきもので、タイトル、サブタイトル、音声、画像などがあります。
//        //        let content = UNMutableNotificationContent()
//        //
//        //        //                title : 通知のタイトル
//        //        //                subtitle : 通知のサブタイトル
//        //        //                body : 通知の本文
//        //        //                sound : 通知時の曲（音源）を設定（nAppleの公式サイトには「aiff、wav、caf」が使用可能と記述されているがmp3も使用可能。ただしどの音源も演奏時間が30秒以下でないと音が鳴らないため注意。）
//        //        //                categoryIdentifier : 通知時に使用するカテゴリIDを設定（n公式サイトや他のサイトでは特に触れられていないが、UNNotificationContentのcategoryIdentifierにUNNotificationCategoryのidentifierと同じIDを設定しないとアクションボタンが設定されないため注意。）
//        //        //                attachments : 通知で表示するイメージ画像を設定
//        //        content.title = "コアラ通知"
//        //        content.subtitle = "コアラがお腹を空かせてます"
//        //        content.body = "aaaaaaa"
//        //        content.sound = UNNotificationSound.default
//        //
//        //        //トリガーは、通知を表示するタイミングを決定するもので、現在からの秒数、将来の日付と時間、または場所を指定することができます。
//        //        //UNTimeIntervalNotificationTriggerは、今から特定の秒数で表示される通知を要求することができるようにするものです。
//        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        //
//        //        // choose a random identifier
//        //        //このリクエストはコンテンツとトリガーを結合するだけでなく、後で特定のアラートを編集したり削除したりできるように、一意の識別子を追加します。もし編集や削除をしたくない場合は、UUID().uuidString を使ってランダムな識別子を取得してください。
//        //        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//        //
//        //        // add our notification request
//        //        UNUserNotificationCenter.current().add(request)
//    }
    
    func numToDate(num: Int) -> String{
        switch num{
        case 1:
            return "日曜"
        case 2:
            return "月曜"
        case 3:
            return "火曜"
        case 4:
            return "水曜"
        case 5:
            return "木曜"
        case 6:
            return "金曜"
        case 7:
            return "土曜"
        default:
            return ""
        }
    }
}


struct Notification_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView().environmentObject(ViewModel())
    }
}
