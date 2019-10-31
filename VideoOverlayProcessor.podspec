Pod::Spec.new do |s|
  s.name           = 'VideoOverlayProcessor'
  s.version        = '1.0.0'
  s.license        = { type: 'MIT', file: 'LICENSE' }
  s.summary        = 'A library to simplify adding overlays to video'
  s.description    = 'VideoOverlayProcessor is a clean and easy-to-use library responsible for adding image and text overlays to video.'
  s.homepage       = 'https://github.com/inspace-io/VideoOverlayProcessor'
  s.author         = { "Dawid Płatek" => "dawid@inspace.io" }
  s.source         = { git: 'https://github.com/inspace-io/VideoOverlayProcessor.git', tag: s.version.to_s }

  s.source_files   = 'VideoOverlayProcessor/Classes/**/*'

  s.platform       = :ios, '8.0'
  s.frameworks     = 'UIKit', 'Foundation', 'AVFoundation'
  s.swift_version  = '5.0'
end
