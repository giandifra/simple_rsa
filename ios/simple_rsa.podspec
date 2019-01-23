#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'simple_rsa'
  s.version          = '0.0.3'
  s.summary          = 'A simple RSA plugin for flutter.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/adlanarifzr'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Adlan Arif Zakaria' => 'adlanarifzr@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SwiftyRSA', "~> 1.5.0"
  s.ios.deployment_target = '8.3'
end

