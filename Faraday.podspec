Pod::Spec.new do |spec|
  spec.name = 'Faraday'
  spec.version = '0.1.0'
  spec.summary = 'Flexible HTTP client framework based on Rack'
  spec.homepage = 'https://github.com/royratcliffe/Faraday'
  spec.license = { type: 'MIT', file: 'MIT-LICENSE.txt' }
  spec.author = { 'Roy Ratcliffe' => 'roy@pioneeringsoftware.co.uk' }
  spec.source = { git: 'https://github.com/royratcliffe/Faraday.git', tag: spec.version.to_s }
  spec.source_files = 'Faraday/**/*.swift'
  spec.public_header_files = 'Faraday/**/*.h'
  spec.platform = :ios, '9.0'
  spec.requires_arc = true
end
