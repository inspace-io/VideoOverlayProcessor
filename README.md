[![](http://inspace.io/github-cover.jpg)](http://inspace.io)

# Introduction

**VideoOverlayProcessor** was written by **[Dawid Płatek](https://github.com/dader)** for **[inspace.io](http://inspace.io)**

# VideoOverlayProcessor

**VideoOverlayProcessor** is a clean and easy-to-use library responsible for adding image and text overlays to video.


## Features

* **Solid performance**: <br/> `VideoOverlayProcessor` is using `AVFoundation` framework under the hood. The whole logic is based on `AVMutableComposition` and the input video is processed only once to keep it as efficient as possible.

* **Time range support** <br/> Visibility of the overlays can be specified by defining exact time range.

* **Positioning and sizing** <br/> The position and the size of overlay can be be easily configured by defined `frame`.

## Getting Started

### Creating a processor

The base class responsible for video processing is called `VideoOverlayProcessor`. To start using the library you have to just create a new object of this class and pass `inputURL` and `outputURL` parameters. The process can give you some additional information about the input file i.e. to calculate the frame of overlay correctly or to set the time range (`videoSize` and `videoDuration` properties respectively).

```Swift
let inputURL = ...
let outputURL = ...

let processor = VideoOverlayProcessor(inputURL: inputURL, outputURL: inputURL)
```

### Adding overlays

There are two classes responsible for adding text and image overlays to video: `TextOverlay` and `ImageOverlay` You should use them to constructed hierarchy of your overlay structure. To defined positioning and sizing you have to set `frame` property. Beside that, you can specify the time range which indicates when the overlay is visible. To achive it you have to use `delay` and `duration` properties. When the overlay object is configured accordingly the last thing you have to do before start processing is adding the object to processor (you should use `addOverlay` method of processing in this case).

```Swift

let videoSize = processor.videoSize
let videoDuration = processor.videoDuration

let textOverlay = TextOverlay(text: "Welcome on github.com!", frame: CGRect(x: 0, y: 0, width: videoSize.width, height: videoSize.height/4), delay: 0.0, duration: videoDuration)
processor.addOverlay(textOverlay)

let image = UIImage(named: ...)
let imageOverlay = ImageOverlay(image: image, frame: CGRect(x: videoSize.width/2-image.size.width/2, y: videoSize.height/2-image.size.height/2, width: image.size.width, height: image.size.height), delay: 0.0, duration: videoDuration)
processor.addOverlay(imageOverlay)

```

### Starting processing

You can start processing by calling `process` method.

## Use cases

**VideoOverlayProcessor** can simplify the whole process of adding overlays to video. There are some common use cases which may give an idea how potentially you use this library.

### Adding a watermark to video

```Swift

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

```

### Adding subtitles to video

```Swift

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

```

## Installation

**VideoOverlayProcessor** will be compatible with the lastest public release of Swift.

### CocoaPods

**VideoOverlayProcessor** is available through [CocoaPods](https://cocoapods.org). To install it, add the following to your `Podfile`:

`pod 'VideoOverlayProcessor'`

## Requirements

* iOS 8.0+
* Xcode 8.0+

## Licence

VideoOverlayProcessor is released under the MIT license. See LICENSE for details.
