$: << File.expand_path('../lib')
require 'hook-client'
require 'logger'
require 'json'

logger = Logger.new(STDOUT)
app = JSON.parse(File.open('spec/app.json').read)
app_key = app['keys'].select{|k| k['type'] == 'server' }.first

Hook::Client.configure(
  :app_id => app_key['app_id'],
  :key => app_key['key'],
  :endpoint => 'http://hook.dev/public/index.php/'
  # :logger => logger
)
