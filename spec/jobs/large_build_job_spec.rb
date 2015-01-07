require 'spec_helper'

describe LargeBuildJob do
  it 'is buildable' do
    expect(LargeBuildJob.included_modules).to include(Buildable)
  end
end
