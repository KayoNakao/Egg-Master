//
//  ViewController.swift
//  Egg Master
//
//  Created by 中尾 佳代 on 2019/02/28.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var imageViewTag = 0
    
    enum eggTimerTag: Int, CaseIterable{
        case  tag6 = 6
        case  tag7 = 7
        case  tag8 = 8
        case  tag9 = 9
        case  tag10 = 10
        case  tag12 = 12
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            for stackview in self.view.subviews {
                if let stackview2 = stackview as? UIStackView{
                    for stackView3 in stackview2.arrangedSubviews {
                        if let stackview4 = stackView3 as? UIStackView{
                            for stackview5 in stackview4.arrangedSubviews{
                                if let buttonView = stackview5 as? UIStackView{
                                    for imageView in buttonView.arrangedSubviews{
                                        if let eggImage = imageView as? UIImageView{
                                           
                                            let action: Selector = #selector(self.imageViewPressed(gesture:))
                                            let gesture = UITapGestureRecognizer(target: self, action: action)
                                            gesture.numberOfTapsRequired = 1
                                            gesture.numberOfTouchesRequired = 1
                                            
                                            eggImage.isUserInteractionEnabled = true
                                            eggImage.addGestureRecognizer(gesture)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    
    @objc func imageViewPressed(gesture: UITapGestureRecognizer) {
        
        imageViewTag = (gesture.view?.tag)!
            performSegue(withIdentifier: "toTimer", sender: self)
    }
    
    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toTimer"{
            let vc = segue.destination as! TimerViewController
            vc.timerLength = Double(imageViewTag * 60)
        }
    }
    
}


