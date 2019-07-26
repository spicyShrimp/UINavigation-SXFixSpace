Pod::Spec.new do |s|

  s.name         = "UINavigation-SXFixSpace"
  s.version      = "1.2.4"
  s.summary      = "导航栏按钮位置偏移的解决方案."
  s.description  = "导航栏按钮位置偏移的解决方案,支持iOS7~iOS13,可自定义间距"
  s.homepage     = "https://github.com/spicyShrimp/UINavigation-SXFixSpace"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "charles" => "78268731@qq.com" }
  s.social_media_url   = "https://github.com/spicyShrimp"
  s.source       = { :git => "https://github.com/spicyShrimp/UINavigation-SXFixSpace.git", :tag => s.version }
  s.source_files  = "UINavigation-SXFixSpace/*.{h,m}"
  s.ios.deployment_target = '7.0'
  s.requires_arc = true

end
