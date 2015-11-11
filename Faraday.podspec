Pod::Spec.new do |spec|
  spec.name = 'Faraday'
  spec.version = '0.0.1'
  spec.summary = 'Flexible HTTP client framework based on Rack'
  spec.homepage = 'https://github.com/royratcliffe/Faraday'
  spec.license = { type: 'MIT', file: 'MIT-LICENSE.txt' }
  spec.author = { 'Roy Ratcliffe' => 'roy@pioneeringsoftware.co.uk' }
  spec.source = { git: 'https://github.com/royratcliffe/Faraday.git', tag: '0.0.1' }
  spec.source_files = 'Faraday/**/*.{swift,h}'
  spec.platform = :ios, '9.0'
end
