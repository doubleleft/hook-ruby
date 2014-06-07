describe DL::Collection do

  subject do
    DL::Client.new(
      :app_id => 1,
      :key => '0a5e6b4ab26bdf5f0da793346f96ad73',
      :endpoint => 'http://dl-api.dev/api/index.php/'
    )
  end

  it "should create new items to collection" do
    subject.create()
  end

end
