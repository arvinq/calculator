//
//  CustomButton.swift
//  calculator
//
//  Created by Arvin Quiliza on 3/21/19.
//  Copyright © 2019 arvnq. All rights reserved.
//

import UIKit

class CalcButton: UIButton {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = self.bounds.height / 5
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //shrink the button
        transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //when touch ended, animate back to default
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0, options: .allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform.identity
                    }, completion: nil)
        
        super.touchesEnded(touches, with: event)
    }

}
