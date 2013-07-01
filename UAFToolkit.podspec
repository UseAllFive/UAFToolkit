Pod::Spec.new do |s|
  s.name         = "UAFToolkit"
  s.version      = "0.1.1"
  s.summary      = "UAFToolkit makes life easier."
  s.description  = <<-DESC
                    UAFToolkit derives mainly from SSToolkit. In addition to
                    modernizing SSToolkit, it builds on the latter with other
                    additions, including improved modularity. UAFToolkit is also
                    meant to selectively track SSToolkit.
                   DESC
  s.homepage     = "http://useallfive.github.io/UAFToolkit"
  s.license      = "MIT"
  s.authors      = { "Peng Wang"   => "peng@pengxwang.com",
                     "Sam Soffes"  => "sam@soff.es" }
  s.source       = { :git => "https://bitbucket.org/hlfcoding/uaftoolkit.git",
                     :tag => "0.1.0" }
  s.platform     = :ios, '5.0'
  s.requires_arc = true

  s.subspec 'Utility' do |us|
    us.source_files   = 'Code/Utility'
    us.frameworks     = 'Foundation', 'CoreGraphics'
  end

  s.subspec 'Foundation' do |fs|
    fs.source_files   = 'Code/Foundation'
    fs.frameworks     = 'Foundation'
  end

  s.subspec 'UIKit' do |uiks|
    uiks.source_files  = 'Code/UIKit'
    uiks.frameworks    = 'UIKit', 'QuartzCore'
    uiks.dependency      'UAFToolkit/Utility'
  end

  s.subspec 'Boilerplate' do |bs|
    bs.source_files   = 'Code/Boilerplate'
    bs.dependency       'UAFToolkit/UIKit'
    bs.dependency       'UAFToolkit/Navigation'
  end

  s.subspec 'Keyboard' do |ks|
    ks.source_files   = 'Code/Keyboard'
    ks.dependency       'UAFToolkit/UIKit'
  end

  s.subspec 'Navigation' do |ns|
    ns.source_files   = 'Code/Navigation'
    ns.dependency       'UAFToolkit/Boilerplate'
    ns.dependency       'UAFToolkit/UI'
  end

  s.subspec 'Storage' do |ss|
    ss.source_files   = 'Code/Storage'
    ss.dependency       'RestKit/Network'
    ss.dependency       'UAFToolkit/Utility'
  end

  s.subspec 'StoreKit' do |ss|
    ss.source_files   = 'Code/StoreKit'
    ss.frameworks     = 'StoreKit', 'CoreData'
  end

  s.subspec 'SFX' do |sfx|
    sfx.source_files  = 'Code/SFX'
    sfx.frameworks    = 'Foundation', 'AVFoundation', 'CoreMedia', 'AudioToolbox'
  end

  s.subspec 'UI' do |uis|
    uis.source_files  = 'Code/UI'
    uis.dependency      'UAFToolkit/Utility'
    uis.dependency      'UAFToolkit/Boilerplate'
  end

end
