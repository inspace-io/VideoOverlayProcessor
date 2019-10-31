//
//  ImageOverlay.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import UIKit

class ImageOverlay: BaseOverlay {
    let image: UIImage
    
    override var layer: CALayer {
        let imageLayer = CALayer()
        imageLayer.contents = image.cgImage
        imageLayer.backgroundColor = backgroundColor.cgColor
        imageLayer.frame = frame
        imageLayer.opacity = 0.0
        
        return imageLayer
    }
    
    init(image: UIImage,
         frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {
        
        self.image = image
        
        super.init(frame: frame, delay: delay, duration: duration, backgroundColor: backgroundColor)
    }
}
