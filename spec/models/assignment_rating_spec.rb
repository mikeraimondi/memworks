require 'spec_helper'

describe AssignmentRating do
  it { should validate_presence_of(:helpful) }

  it { should belong_to(:user) }
  it { should belong_to(:assignment) }
end
