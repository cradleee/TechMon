//
//  LobbyViewController.swift
//  TechMon
//
//  Created by kamano yurika on 2018/02/13.
//  Copyright © 2018年 釜野由里佳. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var staminaLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var stamina: Int = 100
    var staminaTimer: Timer!
    
    //アプリが起動した時一度だけ呼ばれる
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //UIの設定
        nameLabel.text = "勇者"
        staminaLabel.text = " \(stamina) 100"
                             //★1「stamina」という変数の値を文字列の中に表示させるにはどう書けばいい？
        
        //タイマーの設定 //★ここに３秒ごとびupdateStaminaValueを繰り返し実行するタイマーのコードを
        staminaTimer = Timer.scheduledTimer(
            timeInterval: 3,
            target: self,
            selector: #selector(updateStaminaValue),
            userInfo: nil,
            repeats: true)
        staminaTimer.fire()
    }
    
    //ロビー画面が見えるようになるときに呼ばれる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "lobby")
    }
    
    //ロビー画面が見えなくなるときに呼ばれる
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func toBattele() {
        //スタミナが50以上あればスタミナ50を消費して戦闘画面へ
        //★staminaが50以上なら上を、それ以外なら下を実行するというコード
        if stamina >= 50 {
            
            stamina -= 50
            staminaLabel.text = "\(stamina) / 100"
            performSegue(withIdentifier: "toBattle", sender: nil)
        } else {
            
            let alert = UIAlertController(
                title: "バトルに行けません",
                message: "スタミナをためてください",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated:  true, completion:  nil)
            
        }
    }

    //スタミナの回復
    @objc func updateStaminaValue() {
        
        if stamina < 100 {
            
            stamina += 1
            staminaLabel.text = "\(stamina) / 100"
        }
}
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
