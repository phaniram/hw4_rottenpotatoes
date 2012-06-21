require 'spec_helper'

describe Movie do
  describe 'get for ratings from db' do
    it 'has to return list of hardcoded ratings' do
      r = Movie.all_ratings
      r.length.should == 5
    end
  end
end
