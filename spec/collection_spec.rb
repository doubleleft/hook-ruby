describe DL::Collection do

  subject do
    DL::Client.new(
      :app_id => 1,
      :key => '0a5e6b4ab26bdf5f0da793346f96ad73',
      :endpoint => 'http://dl-api.dev/api/index.php/'
    )
  end

  it "should create new items to collection" do
    user = subject.collection(:users).create(:name => "Endel", :newsletter => true)
    expect(user['name']).to eq("Endel")
    expect(user['newsletter']).to eq(true)
  end

  it "should query for items" do
    rows = subject.collection(:users).where(:name => "Endel").all
    expect(rows.length).to be > 0
  end

  it "should delete all items" do
    # create a dummy item
    subject.collection(:users).create(:name => "Endel", :newsletter => true)
    # remove every items
    subject.collection(:users).delete
    rows = subject.collection(:users).where(:name => "Endel").all
    expect(rows.length).to be == 0
  end

  it "should filter items" do
  end

end
