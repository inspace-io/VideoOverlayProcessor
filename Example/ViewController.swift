//
//  ViewController.swift
//  Example
//
//  Created by Dawid Płatek on 30/10/2019.
//  Copyright © 2019 Inspace Labs. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func playSampleVideoButtonTapped(_ sender: Any) {
        guard let url = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        showPlayerViewController(for: url)
    }
    
    @IBAction func addWatermarkButtonTapped(_ sender: Any) {
        guard let inputURL = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("output-\(Int(Date().timeIntervalSince1970)).mp4")
        
        let processor = VideoOverlayProcessor(inputURL: inputURL, outputURL: outputURL)
        
        let videoSize = processor.videoSize
        let videoDuration = processor.videoDuration

        guard let image = UIImage(named: "overlay") else { return }
        let margin: CGFloat = 100
        let imageOverlay = ImageOverlay(image: image, frame: CGRect(x: videoSize.width-image.size.width-margin, y: videoSize.height-image.size.height/2-margin, width: image.size.width/2, height: image.size.height/2), delay: 0.0, duration: videoDuration)
        processor.addOverlay(imageOverlay)
        
        processor.process { [weak self] (exportSession) in
            guard let exportSession = exportSession else { return }
            
            if (exportSession.status == .completed) {
                DispatchQueue.main.async { [weak self] in
                    self?.showPlayerViewController(for: outputURL)
                }
            }
        }
    }
    
    @IBAction func addSubtitlesButtonTapped(_ sender: Any) {
        guard let inputURL = Bundle.main.url(forResource: "sample", withExtension: "mp4") else { return }
        
        let outputURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("output-\(Int(Date().timeIntervalSince1970)).mp4")
        
        let processor = VideoOverlayProcessor(inputURL: inputURL, outputURL: outputURL)
        
        let videoSize = processor.videoSize
        let videoDuration = processor.videoDuration

        let textOverlay = TextOverlay(text: "Hello ;) I hope you like this library", frame: CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height/12), delay: 0.0, duration: videoDuration, backgroundColor: UIColor.black.withAlphaComponent(0.3), textColor: UIColor.white)
        processor.addOverlay(textOverlay)
        
        processor.process { [weak self] (exportSession) in
            guard let exportSession = exportSession else { return }
            
            if (exportSession.status == .completed) {
                DispatchQueue.main.async { [weak self] in
                    self?.showPlayerViewController(for: outputURL)
                }
            }
        }
    }
    
    private func showPlayerViewController(for url: URL) {
        let videoPlayer = AVPlayer(url: url)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
        
        present(playerViewController, animated: true) {
            if let player = playerViewController.player {
                player.play()
            }
        }
    }
}

