describe Hook::Keys do

  subject do
    Hook::Client.instance
  end

  it "should get and set keys" do
    expect(subject.keys.get(:inexistent)).to be_nil

    subject.keys.set :numeric, 12345
    expect(subject.keys.get(:numeric)).to be == 12345

    subject.keys.set :float, 19.99
    expect(subject.keys.get(:float)).to be == 19.99

    subject.keys.set :string, 'hello there!'
    expect(subject.keys.get(:string)).to be == 'hello there!'
  end
end

