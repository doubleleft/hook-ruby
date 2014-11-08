describe Hook::Extensions do
  it "should extend core Ruby classes" do
    gt = :field_gt.gt
    expect(gt.comparation).to eq('>')
    expect(gt.field).to eq(:field_gt)

    gte = :field_gte.gte
    expect(gte.comparation).to eq('>=')
    expect(gte.field).to eq(:field_gte)

    lt = :field_lt.lt
    expect(lt.comparation).to eq('<')
    expect(lt.field).to eq(:field_lt)

    lte = :field_lte.lte
    expect(lte.comparation).to eq('<=')
    expect(lte.field).to eq(:field_lte)

    ne = :field_ne.ne
    expect(ne.comparation).to eq('!=')
    expect(ne.field).to eq(:field_ne)

    _in = :field_in.in
    expect(_in.comparation).to eq('in')
    expect(_in.field).to eq(:field_in)

    not_in = :field_not_in.not_in
    expect(not_in.comparation).to eq('not_in')
    expect(not_in.field).to eq(:field_not_in)

    nin = :field_nin.nin
    expect(nin.comparation).to eq('not_in')
    expect(nin.field).to eq(:field_nin)

    like = :field_like.like
    expect(like.comparation).to eq('like')
    expect(like.field).to eq(:field_like)

    between = :field_between.between
    expect(between.comparation).to eq('between')
    expect(between.field).to eq(:field_between)

    not_between = :field_not_between.not_between
    expect(not_between.comparation).to eq('not_between')
    expect(not_between.field).to eq(:field_not_between)
  end
end
