class Challenge < ActiveRecord::Base
  attr_accessible :lesson_id, :position, :title

  validates_presence_of :lesson_id
  validates_presence_of :title
  validates_presence_of :position
  validates_presence_of :lesson

  has_many  :challenge_progressions,
            inverse_of: :challenge

  has_many  :users,
            through: :challenge_progressions,
            inverse_of: :challenges

  belongs_to  :lesson,
              inverse_of: :challenges

  has_many  :challenge_decks,
            inverse_of: :challenge

  has_many  :cards,
            through: :challenge_decks,
            inverse_of: :challenges
end
