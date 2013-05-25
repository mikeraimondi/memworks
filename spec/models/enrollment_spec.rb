require 'spec_helper'

describe Enrollment do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:lesson_id) }
  it { should validate_presence_of(:last_accessed_at) }

  it { should belong_to(:user) }
  it { should belong_to(:lesson) }
end
