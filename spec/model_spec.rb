class MyCollection
  include DL::Model
  field :name
  field :score
  validates_presence_of :score
end

class CustomHighscore
  include DL::Model
  field :name
  field :score
end

describe DL::Model do
  it "should respond to activemodel dirty methods" do
    instance = MyCollection.new
    expect(instance.name).to be_nil
    expect(instance.name_changed?).to be == false

    instance.name = 'Endel'
    expect(instance.name).to be == 'Endel'
    expect(instance.name_changed?).to be == true

    expect(instance.save).to be == false, "shouldn't save when model has validation errors"
    expect(instance.errors.messages.length).to be == 1
  end

  it "should set default attributes" do
    instance = MyCollection.new(:name => "Endel", :score => 100)
    expect(instance.name).to be == "Endel"
    expect(instance.score).to be == 100
    expect(instance.changed?).to be == true
    instance.save
    expect(instance.changed?).to be == false
  end

  it "general methods" do
    instance = MyCollection.create(:name => "Endel", :score => 100)
    expect(instance.name).to be == "Endel"
    expect(instance.score).to be == 100
    expect(instance.changed?).to be == false
    expect(instance.save).to be == false
  end

  it "should create multiple" do
    rows = CustomHighscore.create([
      {:name => "Somebody", :score => 50},
      {:name => "Anybody", :score => 10},
    ])
    expect(rows.length).to be == 2
    expect(rows[0].name).to be == "Somebody"
    expect(rows[1].name).to be == "Anybody"
    expect(CustomHighscore.delete_all).to be == 2
  end
end
