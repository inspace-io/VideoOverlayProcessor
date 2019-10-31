//
//  TextOverlay.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import UIKit

class TextOverlay: BaseOverlay {
    let text: String
    let textColor: UIColor
    let font: UIFont
    let textAlignment: NSTextAlignment
    
    override var layer: CALayer {
        let textLayer = CATextLayer()
        textLayer.backgroundColor = backgroundColor.cgColor
        textLayer.foregroundColor = textColor.cgColor
        textLayer.string = text
        textLayer.isWrapped = true
        textLayer.font = font
        textLayer.alignmentMode = layerAlignmentMode
        textLayer.frame = frame
        textLayer.opacity = 0.0
        textLayer.displayIfNeeded()
        
        return textLayer
    }
    
    private var layerAlignmentMode: CATextLayerAlignmentMode {
        switch textAlignment {
        case NSTextAlignment.left:
            return CATextLayerAlignmentMode.left
        case NSTextAlignment.center:
            return CATextLayerAlignmentMode.center
        case NSTextAlignment.right:
            return CATextLayerAlignmentMode.right
        case NSTextAlignment.justified:
            return CATextLayerAlignmentMode.justified
        case NSTextAlignment.natural:
            return CATextLayerAlignmentMode.natural
        @unknown default:
            return CATextLayerAlignmentMode.center
        }
    }
    
    init(text: String,
         frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear,
         textColor: UIColor = UIColor.black,
         font: UIFont = UIFont.systemFont(ofSize: 28),
         textAlignment: NSTextAlignment = NSTextAlignment.center) {
        
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
        
        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
