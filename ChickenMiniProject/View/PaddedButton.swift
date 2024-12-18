//
//  PaddedButton.swift
//  ChickenMiniProject
//
//  Created by Lonard Steven on 08/12/24.
//

import UIKit

final class PaddedButton: UIButton {
    var titlePadding: UIEdgeInsets = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel?.sizeToFit()
        
        guard let titleLabel = titleLabel else { return }
        
        // title frame adjustment (padding)
        let buttonWidth = titleLabel.intrinsicContentSize.width + titlePadding.left + titlePadding.right
        let buttonHeight = titleLabel.intrinsicContentSize.height + titlePadding.top + titlePadding.bottom
        
        // set button frame size
        self.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
        
        // new position of titleLabel position
        let titleX = titlePadding.left
        let titleY = titlePadding.top
        
        titleLabel.frame = CGRect(x: titleX,
                                   y: titleY,
                                   width: buttonWidth - titlePadding.left - titlePadding.right,
                                   height: titleLabel.frame.height)
        
        titleLabel.center.y = buttonHeight / 2
        titleLabel.textAlignment = .center
    }
}
