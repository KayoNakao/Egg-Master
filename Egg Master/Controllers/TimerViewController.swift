//
//  TimerViewController.swift
//  Egg Master
//
//  Created by 中尾 佳代 on 2019/03/01.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit
import UserNotifications
import AVFoundation

class TimerViewController: UIViewController, AppDelegateDelegate {

    var timerLength:Double = 0
    var timer: Timer!
    
    var alarmPlayer:AVAudioPlayer!
    
    var isPause = false
    
    let angle_right: CGFloat = 45;
    let angle_left: CGFloat = -45;
    let angle_straight: CGFloat = 0;
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var buttonLable: UIButton!
    @IBOutlet weak var timerLable: UILabel!
    @IBOutlet weak var eggImageView: UIImageView!
    
    enum timerState: String {
        case pause = "Pause"
        case start = "Start"
        case stop = "Stop"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
        
        askNotificationPermittion()
        
        createAudioPlayer()
        
        appDelegate.delegate = self
        appDelegate.isTimerOn = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        timerLable.text = timeFormatted(timerLength)

    }
    
    // Delegate methods from AppdelegateDelegate
    func getTimerRemainings(time: Double) {
        
        timerLength = time
        timerLable.text = timeFormatted(time)
        
        if time <= 0{
            rotateView(angle: angle_straight)
            appDelegate.isTimerOn = false

        }else{
            appDelegate.isTimerOn = true
        }

    }

    func setTimerRemainings() -> Double {

        return timerLength
    }
    
    
    //MARK: - Timer Methods
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1 , target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    @objc func runTimedCode() {
        
        //appDelegate.timerLeft = timerLength
        if timerLength > 0{
            
            timerLength -= 1
            timerLable.text = timeFormatted(timerLength)
            
            if Int(round(timerLength)) % 2 == 1{
                rotateView(angle: angle_right)
                
            }else{
                rotateView(angle: angle_left)
            }
        }else {
            timerLable.text = timeFormatted(0)

            timer.invalidate()
            timer = nil
            
            rotateView(angle: angle_straight)
            
            buttonLable.setTitle(timerState.stop.rawValue, for: .normal)
            
            if appDelegate.isTimerOn{
                playAlarm()
            }
        }
    }
    
    
    func timeFormatted(_ totalSeconds: Double) -> String {
        
        let seconds: Int = Int(round(totalSeconds)) % 60
        let minutes: Int = (Int(round(totalSeconds)) / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    //MARK: - Buttons
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        
        switch buttonLable.titleLabel?.text!{
        case timerState.pause.rawValue:
            timer.invalidate()
            buttonLable.setTitle(timerState.start.rawValue, for: .normal)
            
        case timerState.start.rawValue:
            startTimer()
            buttonLable.setTitle(timerState.pause.rawValue, for: .normal)
            
        case timerState.stop.rawValue:
            if alarmPlayer.isPlaying {
                alarmPlayer.stop()
                //alarmPlayer = nil
            }
            
        default:
            break
        }
       
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {

        appDelegate.isTimerOn = false
        alarmPlayer = nil
        if timer != nil {
            timer.invalidate()
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Rotate ImageView
    
    func rotateView(angle: CGFloat) {
    
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1.0, animations: {
                self.eggImageView.transform = CGAffineTransform(rotationAngle: (angle * .pi) / 180.0)
            })
        }
    }
    
    //MARK: - AVAudioPlayer Methods
    func createAudioPlayer(){
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playback, mode: .default, options: [])
            
        } catch  {
            fatalError("Fail set Category \(error)")
        }
        
        // Activate Session
        do {
            try session.setActive(true)
        } catch {
            // Fail activate audio session
            fatalError("Faile activate session")
        } 
    }
    
    
    func playAlarm(){
        
        let soundURL = Bundle.main.url(forResource: "notification", withExtension:"mp3")
        
        do {
            alarmPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            alarmPlayer.numberOfLoops = -1
            
        }catch{
            print(error)
        }
        alarmPlayer.play()
    }
}



//MARK: - Notification Permittion

extension TimerViewController: UNUserNotificationCenterDelegate {
    
    func askNotificationPermittion(){
        if #available(iOS 10.0, *) {
            // iOS 10
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .sound, .alert], completionHandler: { (granted, error) in
                if error != nil {
                    return
                }
                
                if granted {
                    print("Permittion permitted")
                    
                    let center = UNUserNotificationCenter.current()
                    center.delegate = self
                    
                    
                } else {
                    print("Permition denied")
                }
            })
            
        } else {
            // iOS 9 below
            let settings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}
