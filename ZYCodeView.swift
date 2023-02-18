//
//  ZYCodeView.swift
//  ZYCodeView
//
//  Created by zhanyu on 2022/10/25.
//

import UIKit


class ZYCodeView: UIView {
        
    var inviteCode: String = ""
    private var config: ZYCodeConfig!
    private var containerView: UIView!
    private var tmpTextView: UITextView!
    private var codeTextsArray = [ZYTextView]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    init(frame: CGRect, config: ZYCodeConfig) {
        super.init(frame: frame)
        self.config = config
        setUI()
    }
    
    private func setUI() {
        
        tmpTextView = UITextView(frame: self.bounds)
        tmpTextView.delegate = self
        tmpTextView.tintColor = .clear
        containerView = UIView(frame: tmpTextView.bounds)
        containerView.backgroundColor = .white
        tmpTextView.keyboardType = .asciiCapable;

        addSubview(tmpTextView)
        addSubview(containerView)
        
        layoutCodeView()
    }
    
    private func layoutCodeView() {
        
        let h_space: CGFloat = 10
        let count: Int = config.count
        let totalSpace: CGFloat = CGFloat((count - 1)) * h_space
        let defaultSize = CGSize(width: (self.containerView.bounds.width - totalSpace)/CGFloat(count) , height: self.containerView.bounds.height)
        
        for i in 0 ..< config.count {
            let textView = ZYTextView(frame: CGRect(x: CGFloat(i) * (defaultSize.width + h_space), y: 0, width: defaultSize.width, height: defaultSize.height))
            containerView.addSubview(textView)
//            textView.isUserInteractionEnabled = false
            codeTextsArray.append(textView)
        }
    }
    
    /// 让UITextField变成第一响应者, 弹出键盘
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        // 如果点击事件不在containerView上,不要响应
        if !containerView.bounds.contains(point) {
            tmpTextView.resignFirstResponder()
            inviteCode = tmpTextView.text
            if(inviteCode.count == config.count){
                let codeView = codeTextsArray[config.count-1]
                codeView.hiddenAnimation()

            }
            return nil
        }
        if(!tmpTextView.isFirstResponder){
            tmpTextView.becomeFirstResponder()
        }
        // 取消所有光标闪烁
        codeTextsArray.forEach { codeView in
            codeView.hiddenAnimation()
        }
        
        var current = 0
        if inviteCode.count  < codeTextsArray.count {
            if inviteCode.isEmpty {
                current = 0
            }else {
//                current = inviteCode.count + 1
                current = inviteCode.count

            }
            if current < config.count {
                let codeView = codeTextsArray[current]
                codeView.showAnimation()
            }
        }
       else  if inviteCode.count  == codeTextsArray.count && inviteCode.count == config.count{//如果输入满了
            if inviteCode.isEmpty {
                current = 0
            }else {
                current = inviteCode.count
            }
            if current == config.count && IQKeyboardManager.shared().isKeyboardShowing {
                let codeView = codeTextsArray[current-1]
                codeView.showAnimation()
            }
        }

        return containerView
    }
}
extension ZYCodeView: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            if range.location == config.count {
                // 最后一位回车键
                inviteCode = textView.text
                textView.resignFirstResponder()
            }
            return false
        }
      //限制只能输入字母和数字
        let cs = NSCharacterSet.init(charactersIn: ALPHANUM).inverted
        let filtered = text.components(separatedBy: cs).joined(separator: "")
        if text != filtered {
            return false
        }
        
        
        
        // 取消所有光标闪烁
        codeTextsArray.forEach { codeView in
            codeView.hiddenAnimation()
        }
        let digit = range.location
        if digit > config.count - 1 {
            if text.isEmpty {
                // 删除键
                return true
            }
            //修改最后一位
            let codeView = codeTextsArray[config.count - 1]
            codeView.textLabel.text = text.uppercased()
            if(textView.text.count == 6){
                textView.text = textView.text.prefix(5) + text.uppercased()
                inviteCode = textView.text

            }

            if(text.count>0){
                codeView.textLabel.layer.borderColor = UIColor.hexColor(hexValue: 0x07C160).cgColor
                codeView.textLabel.backgroundColor = .white
            }else{
                codeView.textLabel.layer.borderColor = UIColor.hexColor(hexValue: 0xEEEEEE).cgColor
                codeView.textLabel.backgroundColor = UIColor.hexColor(hexValue: 0xEEEEEE, alpha:0.8)
            }
            codeView.hiddenAnimation()
            textView.resignFirstResponder()
            self.endEditing(true)
            
            return true

        }
        
        let codeView = codeTextsArray[range.location]
        codeView.textLabel.text = text.uppercased()

        if(text.count>0){
            codeView.textLabel.layer.borderColor = UIColor.hexColor(hexValue: 0x07C160).cgColor
            codeView.textLabel.backgroundColor = .white
        }else{
            codeView.textLabel.layer.borderColor = UIColor.hexColor(hexValue: 0xEEEEEE).cgColor
            codeView.textLabel.backgroundColor = UIColor.hexColor(hexValue: 0xEEEEEE, alpha:0.8)
        }

        if range.length == 0 {
            var nextCodeView: ZYTextView!
            if range.location == 0 {
                if text.isEmpty {
                    nextCodeView = codeTextsArray[range.location]
                }else {
                    nextCodeView = codeTextsArray[range.location + 1]
                }
                nextCodeView.showAnimation()
            }else {
                if range.location + 1 < config.count {
                    nextCodeView = codeTextsArray[range.location + 1]
                    nextCodeView.showAnimation()
                }else {
                    nextCodeView = codeTextsArray[range.location]
                    nextCodeView.hiddenAnimation()
                }
            }
        }else {
            let nextCodeView = codeTextsArray[range.location]
            nextCodeView.showAnimation()
        }
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        var codeView: ZYTextView!
        textView.text = textView.text.uppercased()
        inviteCode = textView.text
        NSLog("inviteCode%@", inviteCode);
        if textView.text.count == config.count {
            textView.resignFirstResponder()
//            codeView = codeTextsArray[config.count-1]
//            codeView.hiddenAnimation()

        }

    }
}
