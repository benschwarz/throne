$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'throne'
require 'spec'
require 'spec/autorun'

require 'restclient/components'
RestClient.enable Rack::CommonLogger, STDOUT

Spec::Runner.configure do |config|
  
end
