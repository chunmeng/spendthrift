require 'optparse'
require 'optparse/date'
require 'date'
require 'json'

require_relative 'plaid_client'

options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: ruby cli.rb [OPTIONS]'

  opt.on('-s', '--start-date [START DATE]', Date, 'Transaction query start date') do |start_date|
    options[:start_date] = start_date
  end

  opt.on('-e', '--end-date [END DATE]', Date, 'Transaction query end date') do |end_date|
    options[:end_date] = end_date
  end


end.parse!

case ARGV[0]

when 'transactions'

  start_date =  options.key?(:start_date) ? options[:start_date] : Date.today
  end_date = options.key(:end_date)? options[:end_date]: Date.today
  p = PlaidGateway::PlaidClient.new
  t = p.get_all_transactions start_date:start_date, end_date:end_date

  table = Hash.new {|hash, key| hash[key] = []}


  t.each do |item|
  end

when 'test'
  contents = File.read('transactions.json')
  transactions = JSON.parse(contents)

  table = Hash.new {|hash, key| hash[key] =[]}
  transactions.each do |item|
    item.each {|key, value| table[key].push(value)}
  end










else
  puts 'Error - subcommand needs to be provided'
  exit(1)
end
