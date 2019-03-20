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
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        <#code#>
//    }

}
