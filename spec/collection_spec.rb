describe DL::Collection do

  subject do
    DL::Client.new(
      :app_id => 1,
      :key => '0a5e6b4ab26bdf5f0da793346f96ad73',
      :endpoint => 'http://dl-api.dev/api/index.php'
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

  it "general methods" do
    created = subject.collection(:highscores).create(:player => "One", :score => 50)
    expect(created['player']).to eq("One")
    expect(created['score']).to eq(50)

    subject.collection(:highscores).create(:player => "Two", :score => 100)
    subject.collection(:highscores).create(:player => "Three", :score => 25)
    subject.collection(:highscores).create(:player => "Four", :score => 10)
    subject.collection(:highscores).create(:player => "Five", :score => 150)
    subject.collection(:highscores).create(:player => "Six", :score => 125)

    # .all
    all = subject.collection(:highscores).all
    expect(all.length).to be >= 6

    # .first
    five = subject.collection(:highscores).where(:player => "Five").first
    expect(five.name).to eq("Five")

    # .count
    count = subject.collection(:highscores).where(:player => "Five").count
    expect(count).to be >= 6
  end

end
