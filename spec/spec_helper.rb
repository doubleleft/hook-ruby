$: << File.expand_path('../lib')
require 'dl-api'


DL::Client.configure(
  # :app_id => 1,
  # :key => '0a5e6b4ab26bdf5f0da793346f96ad73',
  :app_id => 10,
  :key => '1f143fde82d14643099ae45e6c98c8e1',
  :endpoint => 'http://dl-api.dev/api/index.php/'
)
