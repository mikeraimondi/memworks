FactoryGirl.define do
  factory :answer do
    card
    start_position  1
    end_position    2
  end

  factory :card do
    title         "This is a card title"
    instructions  "These are card instructions"
    problem       "This is a card problem"
    before(:create) do |card|
      card.assignments << FactoryGirl.create(:assignment)
    end
  end

  factory :assignment do
    title           "This is an assignment title"
    instructions    "These are assignment instructions"
    url             "https://thisisanassignmenturl.com"
    assignment_type "text"
    before(:create) do |assignment|
      assignment.syllabuses.new do |syllabus|
        syllabus.lesson = FactoryGirl.create(:lesson)
        syllabus.position = 1
      end
    end
  end

  factory :lesson do
    title "This is a lesson title"
    summary "This is a lesson summary"
  end

end
