
Pod::Spec.new do |s|

  s.name         = "JOKit"
  s.version      = "1.0.00"
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

s.source_files  = 'JOKit/**/JOKit.h'

s.subspec 'Macro' do |ss|
ss.source_files = 'JOKit/**/JOMacro.h'
end

s.subspec 'Utility' do |ss|
ss.source_files = 'JOKit/Utility/**'
end

s.subspec 'Extend' do |ss|
ss.source_files = 'JOKit/Extend/*.{h,m}'
end

#s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libJOProjectBaseSDK" }

s.dependency "AFNetworking", "~> 3.1.0"
s.dependency "JSONModel", "~> 1.3.0"

end
