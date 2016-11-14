
Pod::Spec.new do |s|

  s.name         = "JOKit"
  s.version      = '1.0.38'
  s.summary      = "Project Base SDK"
  s.homepage     = "https://github.com/xinlidexiaoman/JOKit"
  s.license      = "MIT"
  s.author        = { "Joshua" => "505398605@qq.com" }
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/xinlidexiaoman/JOKit.git", :tag => s.version}


#s.resource = 'JOBaseSDK/Resources/**/*.{png,txt,a}'
#s.resources = ['JOBaseSDK/Resources/**/*.{png}']

#s.framework  = "sqlite3"
#s.frameworks = "SystemConfiguration", "Security", "MobileCoreServices", "CoreGraphics"

#s.library   = "sqlite3"
#s.libraries = "sqlite3", "libJOProjectBaseSDK"
#s.vendored_libraries = "JOBaseSDK/Resources/libJOProjectBaseSDK.a"

s.pod_target_xcconfig = { 'OTHER_LDFLAGS' => '-lObjC' }

s.requires_arc = true

s.subspec 'Macro' do |ss|
ss.source_files  = 'JOKit/**/Macro/*.h'
end

non_arc_files = 'JOKit/**/Extend/NSThread+JOExtend.h','JOKit/**/Extend/NSThread+JOExtend.m'
s.subspec 'NoARC' do |ss|
ss.dependency 'JOKit/Macro'
ss.requires_arc = false
ss.source_files = non_arc_files
end

s.subspec 'JOKit' do |ss|
ss.dependency 'JOKit/Macro'
ss.dependency 'JOKit/Extend'
ss.dependency 'JOKit/Utility'
ss.dependency 'JOKit/NoARC'
ss.source_files  = 'JOKit/**/JOKit.h'
end

s.subspec 'Utility' do |ss|
ss.dependency 'JOKit/Macro'
ss.dependency 'JOKit/Extend'
ss.source_files = 'JOKit/**/Utility/**/*.{h,m}'
#ss.public_header_files = 'JOKit/**/Utility/**/*.h'
end

s.subspec 'Extend' do |ss|
ss.dependency 'JOKit/Macro'
ss.ios.exclude_files = non_arc_files
ss.source_files = 'JOKit/**/Extend/*.{h,m}'
end

s.subspec 'UIKit' do |ss|
ss.dependency 'JOKit/JOKit'
ss.source_files = 'JOKit/**/UIKit/**/*.{h,m}'
end

#s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libJOProjectBaseSDK" }

s.dependency "AFNetworking", "~> 3.1.0"
s.dependency "JSONModel", "~> 1.4.0"

end
