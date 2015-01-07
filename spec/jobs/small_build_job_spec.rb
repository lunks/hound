require 'spec_helper'

describe SmallBuildJob do
  it 'is buildable' do
    expect(SmallBuildJob.included_modules).to include(Buildable)
  end
end
