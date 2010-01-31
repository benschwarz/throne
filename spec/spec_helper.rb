$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rubygems'
require 'throne'
require 'spec'
require 'spec/autorun'

# require 'restclient/components'
# RestClient.enable Rack::CommonLogger, STDOUT

unless Throne::Database.setup? :default 
  Throne::Database.setup(:default, "http://127.0.0.1:5984/throne-specs")
  Throne::Database.destroy(:default)
  Throne::Database.create(:default)
end