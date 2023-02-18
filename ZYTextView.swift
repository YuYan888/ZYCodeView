//
//  ZYTextView.swift
//  ZYCodeView
//
//  Created by zhanyu on 2022/10/25.
//

import UIKit


class ZYTextView: UIView {

    var textLabel: UILabel!
//    private var line: UIView!
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    private func setUI(){
        
//        self.layer.cornerRadius = 2
//        self.layer.borderWidth = 1
//        self.layer.borderColor = UIColor.hexColor(hexValue: 0xf0f0f0).cgColor
//        self.backgroundColor = UIColor(red: 238 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 0.8)
        self.backgroundColor = UIColor.hexColor(hexValue: 0xEEEEEE, alpha:0.8)
        self.layer.cornerRadius = 2
        self.layer.masksToBounds = true
        
        textLabel = UILabel(frame: self.bounds)
        textLabel.textAlignment = .center
        textLabel.backgroundColor = UIColor.hexColor(hexValue: 0xEEEEEE, alpha:0.8)
        textLabel.layer.borderWidth = 1
        textLabel.layer.borderColor = UIColor.hexColor(hexValue: 0xEEEEEE).cgColor
        textLabel.layer.cornerRadius = 2

        addSubview(textLabel)
        
//        line = UIView(frame: CGRect(x: (self.bounds.width - 2)/2, y: 0.25*self.bounds.height, width: 2, height: 0.5*self.bounds.height))
//        line.backgroundColor =  UIColor.hexColor(hexValue: 0x07C160)//.red
//        addSubview(line)
//        line.alpha = 0
    }

    private func animation() -> CABasicAnimation {
        
        let basicAnimation = CABasicAnimation(keyPath: "opacity")
        basicAnimation.fromValue = 0.1
        basicAnimation.toValue = 0
        basicAnimation.duration = 0.6
        basicAnimation.autoreverses = true
        basicAnimation.fillMode = .forwards
        basicAnimation.repeatCount = .greatestFiniteMagnitude
        basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        return basicAnimation
    }
    
    func showAnimation() {
        print("showAnimation")
//        self.line.alpha = 0.1
//        if (self.line.layer.animation(forKey: "link") == nil) {
//            self.line.layer.add(animation(), forKey: "link")
//        }
    }
    
    func hiddenAnimation() {

//        self.line.alpha = 0
//        self.line.layer.removeAllAnimations()
    }
}
