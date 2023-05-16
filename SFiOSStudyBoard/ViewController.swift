//
//  ViewController.swift
//  SFiOSStudyBoard
//
//  Created by 沈海超 on 2023/4/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sendTimerEndingNotificaitons()
    }
    
    private func sendTimerEndingNotificaitons() {
        let userInfo: [String: Any] = [
            "aps":
                [
                    "alert":
                    [
                        "title":"iOS10远程推送标题",
                        "subtitle" : "iOS10 远程推送副标题",
                        "body":"这是在iOS10以上版本的推送内容，并且携带来一个图片附件"
                    ],
                    "badge":1,
                    "mutable-content":1,
                    "media":"image",
                    "image-url":"https://tva1.sinaimg.cn/large/008i3skNgy1gtmd6b4whhj60fq0g6tb502.jpg"
                ]
            ]
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "beep.wav"))
        
        content.userInfo = userInfo
        content.title = "沈海超"
        content.body = "nihaoyayayyayayyay"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 6, repeats: false)
        
        let identifier = "pushIdentifier"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }

    func sortTimer() {
        print("hhhh")
        /*排序规则：
        - 若同组内有最新设置的Timer，则该Timer排在组内其他未结束的Timer前面，同时该组排在其他未结束的组前面。
        - 若同组内有最新结束的Timer，则该Timer排在组内最前面，同时该组排在其他所有组前面。
        - 若同组内有同时结束的Timer，则最新设置的Timer排在最前面，同时最新设置的组排在其他组前面。
        */
        
        let time1 = Timer(status: .running, setTime: 49, endTime: 0)
        let time2 = Timer(status: .running, setTime: 54, endTime: 0)
        let time3 = Timer(status: .finished, setTime: 41, endTime: 55)
        let time4 = Timer(status: .finished, setTime: 48, endTime: 55)
        let time5 = Timer(status: .finished, setTime: 42, endTime: 48)
        let time6 = Timer(status: .finished, setTime: 38, endTime: 53)
        let time7 = Timer(status: .finished, setTime: 38, endTime: 51)
        let time8 = Timer(status: .finished, setTime: 43, endTime: 56)
        
        let recipe1 = Recipe(timers: [time1, time2, time3, time4, time5, time6])
        let recipe2 = Recipe(timers: [time1, time2, time8, time5, time6, time7])
        var recipes = [recipe1, recipe2]
        recipes = recipes.map({ recipe in
            var recipe = recipe
            recipe.timers = recipe.timers.sorted(by: { time1, time2 -> Bool in
                return self.sortStepTimer(time1: time1, time2: time2)
            })

            return recipe
        })

        
        recipes = recipes.sorted(by: { recipe1, recipe2 -> Bool in
            guard let timer1 = recipe1.timers.first, let timer2 = recipe2.timers.first else { return false }
            return self.sortStepTimer(time1: timer1, time2: timer2)
        })
//
        print("----------------------------------------")
        recipes.forEach({ recipe in
            
            recipe.timers.forEach({ timer in
                print("status: \(timer.status), setTime: \(timer.setTime), endTime: \(timer.endTime)")
            })
            print("----------------------------------------")
        })
    }
    
    func sortStepTimer(time1: Timer, time2: Timer) -> Bool {
        let max = max(time1.setTime, time1.endTime, time2.setTime, time2.endTime)
        return time1.setTime == max || time1.endTime == max
    }
}



struct Recipe {
    var timers: [Timer]
}

struct Timer {
    var status: Status
    var setTime: Int
    var endTime: Int
}

enum Status {
    case running
    case finished
}
