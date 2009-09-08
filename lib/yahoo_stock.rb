$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'date'
require 'yahoo_stock/scrip_symbol.rb'
require 'yahoo_stock/interface.rb'
require 'yahoo_stock/quote.rb' 
require 'yahoo_stock/history.rb'

module YahooStock
  VERSION = '0.1.3'
end