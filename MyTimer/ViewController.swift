//
//  ViewController.swift
//  MyTimer
//
//  Created by 山本 沙季 on 2018/11/05.
//  Copyright © 2018年 山本 沙季. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //タイマーの変数を作成
    var timer : Timer?
    //カウント(経過時間)の変数を作成
    var count = 0
    //設定値を扱うキーを設定
    let settingKey = "timer_value"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        //UserDefaultsに初期値を登録
        settings.register(defaults: [settingKey : 10])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var countDownLabel: UILabel!
    @IBAction func settingButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true {
                //タイマー停止
                nowTimer.invalidate()
            }
        }
        //画面移動を行う
        performSegue(withIdentifier: "goSetting", sender: nil)
    }
    
    @IBAction func startButtonAction(_ sender: Any) {
        
        let urlSessionGetClient = URLSessionGetClient()
        let queryItems = [URLQueryItem(name: "city", value: "130010")]
        urlSessionGetClient.get(url: "http://weather.livedoor.com/forecast/webservice/json/v1", queryItems: queryItems)
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer{
            //もしタイマーが、実行中だったらスタートしない
            if nowTimer.isValid == true {
                //何も処理しない
                return
            }
        }
        //タイマーをスタート
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self,
                                     selector: #selector(self.timerInterrupt(_:)),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @IBAction func stopButtonAction(_ sender: Any) {
        //timerをアンラップしてnowTimerに代入
        if let nowTimer = timer {
            //もしタイマーが、実行中だったら停止
            if nowTimer.isValid == true {
                //タイマー停止
                nowTimer.invalidate()
            }
        }
    }
    //画面を更新する(戻り値：remainCount：残り時間)
    func displayUpdate() -> Int {
        //UserDefaultsのインスタンスを生成
        let settings = UserDefaults.standard
        //取得した秒数をtimerValueに渡す
        let timerValue = settings.integer(forKey: settingKey)
        //残り時間(remainCount)を生成
        let remainCount = timerValue - count
        //残り時間(remainCount)をラベルに表示
        countDownLabel.text = "残り\(remainCount)秒"
        //残り時間を戻り値に設定
        return remainCount
    }
    //経過時間の処理
    @objc func timerInterrupt(_ timer:Timer) {
        //count（経過時間）に＋１をしていく
        count += 1
        //remainCount(残り時間)が0以下の時、タイマーを止める
        if displayUpdate() <= 0 {
            //初期化処理
            count = 0
            //タイマー停止
            timer.invalidate()
            
            
            //カスタマイズ編：ダイアログを作成
            let alertController = UIAlertController(title: "終了", message: "タイマー終了時間です", preferredStyle: .alert)
            //ダイアログに表示させるOKボタンを作成
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            //アクションを追加
            alertController.addAction(defaultAction)
            //ダイアログの表示
            present(alertController,animated: true,completion: nil)
        }
    }
 //画面切り替えのタイミングで処理を行う
    override func viewDidAppear(_ animated: Bool) {
        //カウント(経過時間)をゼロにする
        count = 0
        //タイマー表示を更新する
        _ = displayUpdate()
    }
}

