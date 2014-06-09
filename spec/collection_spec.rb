describe DL::Collection do

  subject do
    DL::Client.instance
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
    subject.collection(:users).delete_all
    rows = subject.collection(:users).where(:name => "Endel").all
    expect(rows.length).to be == 0
  end

  it "general methods" do
    subject.collection(:highscores).delete_all

    one = created = subject.collection(:highscores).create(:player => "One", :score => 50)
    expect(created['player']).to eq("One")
    expect(created['score']).to eq(50)

    two = subject.collection(:highscores).create(:player => "Two", :score => 100)
    three = subject.collection(:highscores).create(:player => "Three", :score => 25)
    four = subject.collection(:highscores).create(:player => "Four", :score => 10)
    five = subject.collection(:highscores).create(:player => "Five", :score => 150)
    six = subject.collection(:highscores).create(:player => "Six", :score => 125)

    # find multiple by id
    rows = subject.collection(:highscores).find([two['_id'], three['_id']])
    expect(rows.length).to be == 2
    expect(rows[0]['player']).to be == 'Two'
    expect(rows[1]['player']).to be == 'Three'

    # .all
    all = subject.collection(:highscores).all
    expect(all.length).to be >= 6

    # .first
    five = subject.collection(:highscores).where(:player => "Five").first
    expect(five['player']).to eq("Five")

    # .count
    count = subject.collection(:highscores).where(:score.lt => 25).count
    expect(count).to be == 1

    count = subject.collection(:highscores).where(:score.lte => 25).count
    expect(count).to be == 2

    count = subject.collection(:highscores).where(:score.between => 11..149).count
    expect(count).to be == 4

    count = subject.collection(:highscores).where(:player.ne => "One").count
    expect(count).to be == 5
  end

end
