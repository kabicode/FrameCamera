source 'https://github.com/CocoaPods/Specs.git'
# Uncomment this line to define a global platform for your project
platform :ios, '8.0'

target 'PingGuo' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for FrameCamera

  ## Swift
  pod 'Alamofire'
  pod 'SwiftyJSON'
  pod 'Kingfisher', '~> 3.6.0'
  pod 'SnapKit'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
  pod 'DeviceKit', '~> 1.0'
  pod 'Toaster', '~> 2.0.3'

  ## Objective-c
  pod 'MJRefresh'
  pod 'MBProgressHUD'
  pod "TSMessages", :git => 'https://github.com/KrauseFx/TSMessages.git'
  pod 'PSTAlertController', '~> 1.2.0'
  # pod 'Fabric'
  # pod 'Crashlytics'
  
#  pod 'ShareSDK3'
#  pod 'MOBFoundation'
#  pod 'ShareSDK3/ShareSDKUI'
#  pod 'ShareSDK3/ShareSDKExtension'
#  pod 'ShareSDK3/ShareSDKPlatforms/WeChat'
#  pod 'ShareSDK3/ShareSDKPlatforms/SinaWeibo'
#  pod 'ShareSDK3/ShareSDKPlatforms/QQ'

  # 主模块(必须)
  pod 'mob_sharesdk'
  
  # UI模块(非必须，需要用到ShareSDK提供的分享菜单栏和分享编辑页面需要以下1行)
  pod 'mob_sharesdk/ShareSDKUI'
  pod 'mob_sharesdk/ShareSDKExtension'
  
  # 平台SDK模块(对照一下平台，需要的加上。如果只需要QQ、微信、新浪微博，只需要以下3行)
  pod 'mob_sharesdk/ShareSDKPlatforms/QQ'
  pod 'mob_sharesdk/ShareSDKPlatforms/SinaWeibo'
  pod 'mob_sharesdk/ShareSDKPlatforms/WeChat'

  pod 'Qiniu', ' ~> 7.1.5'
  pod 'SSZipArchive'

#  pod 'UMengUShare/UI'
#  pod 'UMengUShare/Social/Sina'
#  pod 'UMengUShare/Social/WeChat'
#  pod 'UMengUShare/Social/QQ'

end
