Pod::Spec.new do |s|
    s.name             = "Encryption"
    s.version          = "1.0.0"
    s.summary          = "加密算法"
    s.description      = <<-DESC
    RSA MD5
    DESC
    s.homepage         = "https://github.com/Z-JaDe"
    s.license          = 'MIT'
    s.author           = { "ZJaDe" => "zjade@outlook.com" }
    s.source           = { :git => "git@github.com:Z-JaDe/Encryption.git", :tag => s.version.to_s }
    
    s.requires_arc          = true
    
    s.ios.deployment_target = '9.0'
    s.frameworks            = "Foundation"
    s.swift_version         = "4.2"

    s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/Sources/openssl/include' }

    s.public_header_files   = "Sources/Utilities/FSOpenSSL.h"
    s.vendored_libraries    = "Sources/openssl/lib/*.a"
    s.source_files          = "Sources/**/*.{swift,h,m}"

end
