Pod::Spec.new do |spec|
  spec.name = 'Faraday'
  spec.version = '0.1.8'
  spec.summary = 'Flexible HTTP client framework based on Rack'
  spec.description = <<-DESCRIPTION
  Flexible HTTP and HTTPS client framework based on Rack. Adopts the concept of
  Rack middleware when processing the HTTP requests and responses.  When you
  build a connection, you set up a stack of middleware components for processing
  requests and their responses.
  DESCRIPTION
  spec.homepage = 'https://github.com/royratcliffe/Faraday'
  spec.license = { type: 'MIT', file: 'MIT-LICENSE.txt' }
  spec.author = { 'Roy Ratcliffe' => 'roy@pioneeringsoftware.co.uk' }
  spec.source = {
    git: 'https://github.com/royratcliffe/Faraday.git',
    tag: spec.version.to_s }
  spec.source_files = 'Faraday/**/*.{swift,h}'
  spec.platform = :ios, '9.0'
  spec.requires_arc = true
end
