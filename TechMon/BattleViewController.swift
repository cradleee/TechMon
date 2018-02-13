//
//  BattleViewController.swift
//  TechMon
//
//  Created by kamano yurika on 2018/02/13.
//  Copyright © 2018年 釜野由里佳. All rights reserved.
//

import UIKit

class BattleViewController: UIViewController {
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerImageView: UIImageView!
    @IBOutlet var playerHPLabel: UILabel!
    @IBOutlet var playerMPLabel: UILabel!
    
    @IBOutlet var enemyNameLabel: UILabel!
    @IBOutlet var enemyImageView: UIImageView!
    @IBOutlet var enemyHPLabel: UILabel!
    @IBOutlet var enemyMPLabel: UILabel!
    
    let techMonManager = TechMonManager.shared
    
    var player: Character!
    var enemy: Character!
    var gameTimer: Timer!
    var isPlayerAttackAvailable: Bool = true

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //キャラクターの読み込み
        player = techMonManager.player
        enemy = techMonManager.enemy
        
        //UIの設定

        //プレイヤーのステータスを反映
        playerNameLabel.text = "勇者"
        playerImageView.image = UIImage(named: "yusya.png")
        playerHPLabel.text = "\(player) / 100"
        playerMPLabel.text = "\(player) / 20"
        //敵のステータスを反映
        enemyNameLabel.text = "敵"
        enemyImageView.image = UIImage(named: "monster.png")
        enemyHPLabel.text = "\(enemy) / 200"
        enemyMPLabel.text = "\(enemy) / 35"
        
        //ゲームスタート
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateGame), userInfo: nil, repeats: true)
        
        gameTimer.fire()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        techMonManager.playBGM(fileName: "BGM_battle001")
    }
    
    override func viewWillDisappear(_ animated: Bool){

        super.viewWillDisappear(animated)
        techMonManager.stopBGM()
    }
   //0.1秒ごとにゲームの状態を更新する
    @objc func updateGame() {
        
        //ステータスを反映
        func updateUI() {
            
            //プレイヤーのステータスを反映
            playerHPLabel.text = "\(player.currentHP) / \(player.maxHP)"
            playerMPLabel.text = "\(player.currentMP) / \(player.maxMP)"
            
            //敵のステータスを反映
            enemyHPLabel.text = "\(enemy.currentHP) / \(enemy.maxHP)"
            enemyMPLabel.text = "\(enemy.currentMP) / \(enemy.maxMP)"
        }
        
        //プレイヤーのステータスを更新
        player += 1
        if player >= 20 {
            
            isPlayerAttackAvailable = true
            player = 20
        } else {
            
            isPlayerAttackAvailable = false
        }
        
        //敵のステータスを更新
        enemy += 1
        if enemy >= 35 {
            
            enemyAttack()
            enemy = 0
        }
        
        playerMPLabel.text = "\(player) / 20"
        enemyMPLabel.text = "\(enemy) / 35"
    }
    
    //敵の攻撃
    func enemyAttack() {
        
        techMonManager.damageAnimation(imageView: playerImageView)
        techMonManager.playSE(fileName: "SE_attack")
        
        player -= 20
        
        playerHPLabel.text = "\(player) / 100"
        
        if player <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin:false)
        }else if enemy.currentHP <= 0 {
            finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
        }
    }
    
    //勝負判定をする
    func judgeBattle() {
        if player.currentHP <= 0 {
            finishBattle(vanishImageView: playerImageView, isPlayerWin: true)
        }
    }
    //勝負が決定した時の処理
    func finishBattle(vanishImageView: UIImageView, isPlayerWin: Bool) {
        
        techMonManager.vanishAnimation(imageView: vanishImageView)
        techMonManager.stopBGM()
        gameTimer.invalidate()
        isPlayerAttackAvailable = false
        
        var finishMessage: String = ""
        if isPlayerWin {
            
            techMonManager.playSE(fileName: "SE_fanfare")
            finishMessage = "勇者の勝利！！"
        } else {
            
            techMonManager.playSE(fileName: "SE_gameover")
            finishMessage = "勇者の敗北..."
        }
        
        let alert = UIAlertController(title: "バトル終了", message: finishMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.dismiss(animated: true, completion: nil)
        }))
    }
    
    @IBAction func attackAction() {
        if isPlayerAttackAvailable {
            
            techMonManager.damageAnimation(imageView: enemyImageView)
            techMonManager.playSE(fileName: "SE_attack")
            
            enemy -= 30
            player = 0
            
            enemyHPLabel.text = "\(enemy) / 200"
            playerMPLabel.text = "\(player) / 20"
            
            if enemy <= 0 {
                
                finishBattle(vanishImageView: enemyImageView, isPlayerWin: true)
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
