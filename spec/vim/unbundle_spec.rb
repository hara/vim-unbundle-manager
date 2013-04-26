require 'spec_helper'

describe Vim::Unbundle do
  it 'should have a version number' do
    Vim::Unbundle::VERSION.should_not be_nil
  end
end
