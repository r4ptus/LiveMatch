//
//  CardView.swift
//  LiveMatch
//
//  Created by ema on 04.07.19.
//  Copyright © 2019 raptus. All rights reserved.
//

import UIKit

@IBDesignable class CardView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet var queueType: UILabel!
    @IBOutlet var rank: UILabel!
    @IBOutlet var leaguePoints: UILabel!
    @IBOutlet var icon: UIImageView!
    @IBInspectable var cornerRadius: Double {
        get {
            return Double(self.layer.cornerRadius)
        }set {
            self.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable var borderWidth: Double {
        get {
            return Double(self.layer.borderWidth)
        }
        set {
            self.layer.borderWidth = CGFloat(newValue)
        }
    }
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue?.cgColor
        }
    }
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    /**
     Initializes a new CardView
     
     - Parameters:
     frame: CGRect
     
     - Returns: a CardView
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    /**
     Initializes a new CardView from code
     
     - Parameters:
     coder aDecoder: NSCoder
     
     - Returns: a CardView
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    /**
     sets up the a new CardView
     */
    private func commonInit() {
        Bundle.main.loadNibNamed("CardView", owner: self, options: nil)
        addSubview(view)
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
