//
//  BaseOverlay.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import UIKit
import AVFoundation

class BaseOverlay {
    let frame: CGRect
    let delay: TimeInterval
    let duration: TimeInterval
    let backgroundColor: UIColor
    
    var startAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = timeRange.start.seconds == 0.0 ? 1.0 : 0.0
        animation.toValue = 1.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds
        animation.duration = 0.01 // WORKAROUND: we have to change the duration to avoid animating initial phase
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    var endAnimation: CAAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1.0
        animation.toValue = 0.0
        animation.beginTime = AVCoreAnimationBeginTimeAtZero + timeRange.start.seconds + timeRange.duration.seconds
        animation.duration = 0.01 // WORKAROUND: we have to change the duration to avoid animating final phase
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        
        return animation
    }
    
    var layer: CALayer {
        fatalError("Subclasses need to implement the `layer` property.")
    }
    
    var timeRange: CMTimeRange {
        let timescale: Double = 1000
        
        let startTime = CMTimeMake(value: Int64(delay*timescale), timescale: Int32(timescale))
        let durationTime = CMTimeMake(value: Int64(duration*timescale), timescale: Int32(timescale))
        
        return CMTimeRangeMake(start: startTime, duration: durationTime)
    }
    
    init(frame: CGRect,
         delay: TimeInterval,
         duration: TimeInterval,
         backgroundColor: UIColor = UIColor.clear) {
        
        self.frame = frame
        self.delay = delay
        self.duration = duration
        self.backgroundColor = backgroundColor
    }
}
