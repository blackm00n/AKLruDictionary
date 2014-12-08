Pod::Spec.new do |s|
  s.name = "AKLruDictionary"
  s.platform = :ios
  s.version = "1.0"
  s.summary = "LRU (least recently used) memory cache data structure with a similar API as NSMutableDictionary."
  s.homepage = "https://github.com/blackm00n/AKLruDictionary"
  s.license = 'MIT'
  s.author = { "Aleksey Kozhevnikov" => "aleksey.kozhevnikov@gmail.com" }
  s.platform = :ios, '7.0'
  s.source = { :git => "https://github.com/blackm00n/AKLruDictionary.git", :tag => "v#{s.version.to_s}" }
  s.source_files = 'AKLruDictionary/AKLruDictionary/*.{h,m}'
  s.prefix_header_file = 'AKLruDictionary/AKLruDictionary/AKLruDictionary-Prefix.pch'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
end
