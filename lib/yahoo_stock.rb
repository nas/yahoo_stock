$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'yahoo_stock/interface.rb'
require 'yahoo_stock/quote.rb' 

module YahooStock
  VERSION = '0.0.1'
end