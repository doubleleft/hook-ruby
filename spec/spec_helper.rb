$: << File.expand_path('../lib')
require 'hook-client'
require 'logger'

logger = Logger.new(STDOUT)

Hook::Client.configure(
  # :app_id => 1,
  # :key => '0a5e6b4ab26bdf5f0da793346f96ad73',
  # # :app_id => 10,
  # # :key => '1f143fde82d14643099ae45e6c98c8e1',
  # :endpoint => 'http://dl-api.dev/api/index.php/'

  :app_id => 1,
  :key => '57acfb1a9fa3bcc8d9b72016884b1601',
  :endpoint => 'http://dl-api.herokuapp.com/',
  :logger => logger
)
