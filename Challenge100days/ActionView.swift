//
//  ActionView.swift
//  Challenge100days
//
//  Created by koala panda on 2023/01/29.
//

import SwiftUI



struct ActionView: View {
    ///CoreDataに保存したデータ呼び出し用
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key:"date", ascending: true)]) var days: FetchedResults<DailyData>
    
    ///今日のワークが達成されているかの確認用フラグ
    @State var isComplete = false
    
    ///コンプリートウインドウ出現フラグ
    @State var showCompleteWindew = false
    
    
    @AppStorage("colorkeyTop") var storedColorTop: Color = .blue
    @AppStorage("colorkeyBottom") var storedColorBottom: Color = .green
    
    @AppStorage("longTermGoal") var longTermGoal: String = ""
    @AppStorage("shortTermGoal") var shortTermGoal: String = ""
    
    @AppStorage("showInfomation") var showInfomation = true
    
    var startDate: String{
        makeDate(day:days.first?.date ?? Date.now)
    }
    
    var dayNumber: Int{
        days.count + 1
    }
    
    
    var body: some View {
        NavigationView{
            ZStack{
                
                ///今日のミッションが未達成ならボタンのビューを表示
                VStack(spacing: 20){
//                    HStack{
//                        //Text("目標を表示")
//                        //                        Image(systemName: "chevron.right.circle")
//                        //                            .imageScale(.large)
//                        //                            .fontWeight(.thin)
//                        //                            .rotationEffect(.degrees(showInfomation ? 90 : 0))
//                        //                            .animation(.spring(), value: showInfomation)
//                        
//                        Toggle("目標を表示", isOn: $showInfomation)
//                            .frame(width: AppSetting.screenWidth * 0.4)
//                        Spacer()
//                    }
//                    .frame(width: AppSetting.screenWidth * 0.8)
//                    .foregroundColor(Color(UIColor.label))
//                    //.padding(.top)
//                    .onTapGesture {
//                        withAnimation{
//                            showInfomation.toggle()
//                        }
//                    }
                    
                    VStack(){

                        VStack{
                            //Spacer()
                            if showInfomation{
                                VStack(alignment: .leading, spacing: 0){
                                    HStack{
                                        Text("開始した日  :  ").font(.caption)
                                        Text("\( makeDate(day:days.first?.date ?? Date.now))〜")
                                        //.font(.body)
                                            .font(.callout)
                                    }
                                    .frame(width: AppSetting.screenWidth * 0.75 ,alignment: .leading)
                                    .padding(.bottom, 5)
                                    
                                    Text("目指している姿  :  ").font(.caption)
                                    Text("あああああああ\(longTermGoal)")
                                        .font(.callout)
                                        .frame(width: AppSetting.screenWidth * 0.75 ,alignment: .center)
                                        .padding(.bottom, 5)
                                    //.font(.body)
                                    Text("100日取り組むこと : ").font(.caption)
                                    Text("あああああああ\(shortTermGoal)")
                                        .font(.callout)
                                        .frame(width: AppSetting.screenWidth * 0.75 ,alignment: .center)
                                        //.padding(.bottom, 5)
                                    
                                }
                                .padding(.vertical)
                                .frame(width: AppSetting.screenWidth * 0.8)
                                //.frame(maxHeight: AppSetting.screenWidth * 0.88)
                                .background(.black.opacity(0.1))
                                .cornerRadius(15)
                                .foregroundColor(.primary)
                                .fontWeight(.light)
                                //Spacer()
                            }
                            
                            
                            
                            //.font(.footnote)
                        }.frame(maxHeight: AppSetting.screenHeight/4)
                    }
                    
                   
                

                    
                    SpeechBubble2()
                        .rotation(Angle(degrees: 180))
                        .foregroundColor(.white)
                        .overlay{
                            VStack{

                                VStack{
                                    Text(isComplete ? "本日のチャレンジは達成済みです。\nお疲れ様でした！" : "今日の取り組みが終わったら、\nボタンを押して完了しよう" )
                                    
                                    if isComplete{
                                        Button {
                                            showCompleteWindew = true
                                        } label: {
                                            Text("ウインドウを再表示する")
                                        }
                                        .font(.footnote)
                                        .foregroundColor(.blue)
                                        .padding(.top, 1)
                                        .frame(width: AppSetting.screenWidth * 0.65, alignment: .trailing)
                                    }
                                    
                                }
                                .padding(.vertical)
                            }
                            .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
                            .foregroundColor(.black)
                        }
                        .frame(width: AppSetting.screenWidth * 0.8, height: AppSetting.screenWidth * 0.3)
                        .opacity(0.8)
                        
                    
                    
                    ///Completeボタンが押されたら本日分のDailyDataを保存
                    Button(action: {
                        withAnimation{
                            isComplete = true
                            showCompleteWindew = true
                        }
                        let day = DailyData(context: moc)
                        day.id = UUID()
                        day.date = Date.now
                        day.memo = ""
                        day.num = Int16(dayNumber)
                        try? moc.save()
                    }, label: {
                        CompleteButton(num:isComplete ? dayNumber - 1 : dayNumber)
                            .foregroundStyle(.primary)
                            .opacity(isComplete ? 0.3 : 1.0)
                    })
                    .disabled(isComplete)
                    
                    Spacer()
                    Spacer()
                }
                
                
                
                ///ボタン押下後は完了のビューを重ねて表示
                if showCompleteWindew{
                    CompleteView(showCompleteWindew: $showCompleteWindew)
                        .padding()
                        .transition(.scale)
                }
            }
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.secondary)
            .foregroundStyle(
                .linearGradient(
                    colors: [storedColorTop, storedColorBottom],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            
            .onAppear{
                
                ///アプリ起動時に今日のミッションがすでに完了しているか確認
                let todaysData = days.filter{
                    ///CoreDataに保存されたデータの中に今日と同じ日付が存在するか確認
                    Calendar.current.isDate(Date.now, equalTo: $0.date ?? Date.now, toGranularity: .day)
                }
                
                ///もし同日が存在していたら完了フラグをTrueにする
                if todaysData.isEmpty{
                    isComplete = false
                }else{
                    isComplete = true
                }
            }
            //.navigationTitle("100days Challenge")
            //.navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ActionView_Previews: PreviewProvider {
    static private var dataController = DataController()
    
    static var previews: some View {
        ActionView()
    }
}
