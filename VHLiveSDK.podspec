Pod::Spec.new do |spec|
  
  spec.name         = 'VHLiveSDK'
  spec.version      = '6.2.4'

  spec.summary      = "Vhall iOS SDK #{spec.name.to_s}"
  spec.homepage     = 'https://www.vhall.com'
  spec.author       = { "LiGuoliang" => "guoliang.li@vhall.com" }
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.module_name  = "#{spec.name.to_s}"
  spec.requires_arc = true
  spec.platform     = :ios, '9.0'

  spec.source       = { :http => "https://ipa.e.vhall.com/app/sdk_release/iOS/#{spec.name.to_s}_#{spec.version.to_s}.zip" }
  spec.vendored_frameworks = 'framework/**/*.framework'
  spec.frameworks   = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
  }
end