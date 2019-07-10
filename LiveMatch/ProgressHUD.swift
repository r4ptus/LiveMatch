//
//  ProgressHUD.swift
//  LiveMatch
//
//  Created by ema on 08.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit
///Loadingspinner with text
class ProgressHUD: UIVisualEffectView {
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    /**
     Initializes a new ProgressHUD in the inspector
     
     - Parameters:
        - text: text which is shown on the ProgressHUD
     
     - Returns: A ProgressHUD
     */
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    /**
     Initializes a new ProgressHUD programatically
     
     - Parameters:
        - coder aDecoder: NSCoder
     
     - Returns: a ProgressHUD
     */
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    /**
     sets up the ProgressHUD
     */
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    /**
     overrides the didMoveToSuperiew() func
     */
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let superview = self.superview {
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(x: activityIndicatorSize + 5,
                                 y: 0,
                                 width: width - activityIndicatorSize - 15,
                                 height: height)
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    /**
     shows the ProgressHUD
     */
    func show() {
        self.isHidden = false
    }
    /**
     Hides the ProgressHUD
     */
    func hide() {
        self.isHidden = true
    }
}
