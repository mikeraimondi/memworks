class CreateChallengeDecks < ActiveRecord::Migration
  def change
    create_table :challenge_decks do |t|
      t.integer :challenge_id, null: false
      t.foreign_key :challenges
      t.integer :card_id, null: false
      t.foreign_key :cards

      t.timestamps
    end
  end
end
