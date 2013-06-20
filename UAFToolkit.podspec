Pod::Spec.new do |s|
  s.name         = "UAFToolkit"
  s.version      = "0.1.0"
  s.summary      = "UAFToolkit makes life easier."
  s.description  = <<-DESC
                    UAFToolkit derives mainly from SSToolkit. In addition to modernizing SSToolkit, it builds on the latter with other additions, including improved modularity. UAFToolkit is also meant to selectively track SSToolkit.
                   DESC
  s.homepage     = "http://useallfive.github.io/UAFToolkit"
  s.license      = "MIT"
  s.authors      = { "Peng Wang"   => "peng@pengxwang.com",
                     "Sam Soffes"  => "sam@soff.es" }
  s.source       = { :git => "https://bitbucket.org/hlfcoding/uaftoolkit.git",
                     :tag => "0.1.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'Code', 'Code/**/*.{h,m}'
  s.frameworks   = 'Foundation', 'UIKit', 'AVFoundation', 'CoreMedia', 'QuartzCore', 'CoreGraphics'
  s.requires_arc = true
end
