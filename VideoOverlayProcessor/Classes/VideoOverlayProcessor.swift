//
//  VideoOverlayProcessor.swift
//  VideoOverlayProcessor
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import AVFoundation

class VideoOverlayProcessor {
    let inputURL: URL
    let outputURL: URL
    
    var outputPresetName: String = AVAssetExportPresetHighestQuality
    
    private var overlays: [BaseOverlay] = []
    
    var videoSize: CGSize {
        let asset = AVURLAsset(url: inputURL)
        return asset.tracks(withMediaType: AVMediaType.video).first?.naturalSize ?? CGSize.zero
    }
    
    var videoDuration: TimeInterval {
        let asset = AVURLAsset(url: inputURL)
        return asset.duration.seconds
    }
    
    private var asset: AVAsset {
        return AVURLAsset(url: inputURL)
    }
    
    // MARK: Initializers
    
    init(inputURL: URL, outputURL: URL) {
        self.inputURL = inputURL
        self.outputURL = outputURL
    }
    
    // MARK: Processing
    
    func process(_ completionHandler: @escaping (_ exportSession: AVAssetExportSession?) -> Void) {
        let composition = AVMutableComposition()
        let asset = AVURLAsset(url: inputURL)
        
        guard let videoTrack = asset.tracks(withMediaType: AVMediaType.video).first else {
            completionHandler(nil)
            return
        }
        
        guard let compositionVideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid)) else {
            completionHandler(nil)
            return
        }
        
        let timeRange = CMTimeRangeMake(start: CMTime.zero, duration: asset.duration)

        do {
            try compositionVideoTrack.insertTimeRange(timeRange, of: videoTrack, at: CMTime.zero)
            compositionVideoTrack.preferredTransform = videoTrack.preferredTransform
        } catch {
            completionHandler(nil)
            return
        }
        
        if let audioTrack = asset.tracks(withMediaType: AVMediaType.audio).first {
            let compositionAudioTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: CMPersistentTrackID(kCMPersistentTrackID_Invalid))

            do {
                try compositionAudioTrack?.insertTimeRange(timeRange, of: audioTrack, at: CMTime.zero)
            } catch {
                completionHandler(nil)
                return
            }
        }

        let overlayLayer = CALayer()
        let videoLayer = CALayer()
        overlayLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        videoLayer.frame = CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height)
        overlayLayer.addSublayer(videoLayer)
        
        overlays.forEach { (overlay) in
            let layer = overlay.layer
            layer.add(overlay.startAnimation, forKey: "startAnimation")
            layer.add(overlay.endAnimation, forKey: "endAnimation")
            overlayLayer.addSublayer(layer)
        }

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer, in: overlayLayer)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        _ = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: compositionVideoTrack)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        guard let exportSession = AVAssetExportSession(asset: composition, presetName: outputPresetName) else {
            completionHandler(nil)
            return
        }

        exportSession.outputURL = outputURL
        exportSession.outputFileType = AVFileType.mp4
        exportSession.shouldOptimizeForNetworkUse = true
        exportSession.videoComposition = videoComposition
        exportSession.exportAsynchronously { () -> Void in
            completionHandler(exportSession)
        }
    }
    
    func addOverlay(_ overlay: BaseOverlay) {
        overlays.append(overlay)
    }
}
