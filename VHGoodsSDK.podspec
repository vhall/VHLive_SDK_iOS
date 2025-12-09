Pod::Spec.new do |spec|
  
  spec.name         = 'VHGoodsSDK'
  spec.version      = '6.27.0'

  spec.summary      = "VHall iOS SDK #{spec.name.to_s}"
  spec.homepage     = 'https://www.vhall.com'
  spec.author       = { "GuoChao" => "chao.guo@vhall.com" }
  spec.license      = { :type =>'MIT', :text=><<-LICENSE
    Copyright (c) 2010-2020 VHall Software Foundation (https://www.vhall.com/)
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
    LICENSE
  }
  spec.module_name  = "#{spec.name.to_s}"
  spec.requires_arc = true
  spec.platform     = :ios, '10.0'

  spec.source          = { :git => "https://github.com/vhall/VHLive_SDK_iOS.git", :tag => spec.version.to_s}
  spec.vendored_frameworks = 'VHallSDK/VHGoodsSDK/VHGoodsSDK.framework'
  spec.frameworks   = "AVFoundation", "VideoToolbox","OpenAL","CoreMedia","CoreTelephony" ,"OpenGLES" ,"MediaPlayer" ,"AssetsLibrary","QuartzCore" ,"JavaScriptCore","Security"
  
  spec.pod_target_xcconfig = {
    'FRAMEWORK_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
    'HEADER_SEARCH_PATHS' => '$(inherited) $(PODS_ROOT)/**',
  }
  spec.dependency 'VHLiveSDK', ">=6.24.0"
end
