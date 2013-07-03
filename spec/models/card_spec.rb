# == Schema Information
#
# Table name: cards
#
#  id            :integer          not null, primary key
#  title         :string(255)      not null
#  instructions  :text             not null
#  problem       :text             not null
#  solution_type :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'spec_helper'

describe Card do
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:instructions) }
  it { should validate_presence_of(:problem) }
  it { should validate_presence_of(:assignments) }
  it { should validate_presence_of(:solution_type) }

  it { should have_many(:solution_positions).dependent(:destroy) }
  it { should have_many(:solution_strings).dependent(:destroy) }
  it { should have_many(:card_submissions).dependent(:destroy) }
  it { should have_many(:users) }
  it { should have_many(:card_prerequisites).dependent(:destroy) }
  it { should have_many(:assignments) }
  it { should have_many(:challenge_decks) }
  it { should have_many(:challenges) }

  it { should allow_value("string").for(:solution_type) }
  it { should allow_value("position").for(:solution_type) }
  it { should_not allow_value("invalid").for(:solution_type) }

  context 'with valid attributes' do
    let(:card) { FactoryGirl.create(:card_string_solution) }

    it 'is valid' do
      expect(card).to be_valid
    end
  end

  describe 'has a kind' do
    let(:card_string)   { FactoryGirl.create(:card_string_solution) }
    let(:card_position) { FactoryGirl.create(:card_position_solution) }

    it 'returns "type" if it has a string solution' do
      expect(card_string.kind).to eql("type")
    end

    it 'returns "click" if it has a string solution' do
      expect(card_position.kind).to eql("click")
    end
  end

  describe 'tests a response' do
    context 'with an explicit string response' do
      let(:correct_answer)  { "this is correct" }
      let(:solution)        { FactoryGirl.create(:solution_string,
                              regex: "^#{correct_answer}$") }
      let(:card)            { solution.card }

      it 'returns true if the response is correct' do
        expect(card.correct_answer?(correct_answer)).to be_true
      end

      it 'returns false if the response is incorrect' do
        expect(card.correct_answer?("not correct")).to be_false
      end

      it 'returns false if the response is nil' do
        expect(card.correct_answer?(nil)).to be_false
      end
    end

    context 'with an array of indices' do
      let(:correct_answer)  { {start: '0', end: '1'} }
      let(:solution)        { FactoryGirl.create(:solution_position,
                              start_position: correct_answer[:start],
                              end_position: correct_answer[:end]) }
      let(:card)            { solution.card }

      context 'with a single response' do
        it 'returns true if the response is in the range of solutions' do
          correct_response = [{position: correct_answer[:start]}]
          expect(card.correct_answer?(correct_response)).to be_true
          correct_response = [{position: correct_answer[:end]}]
          expect(card.correct_answer?(correct_response)).to be_true
        end

        it 'returns false if the response is outside the range of solutions' do
          incorrect_response = [{position: 9000}]
          expect(card.correct_answer?(incorrect_response)).to be_false
        end
      end

      context 'with many responses' do
        it 'returns true if all the responses are in the range of solutions' do
          correct_responses = [ {position: correct_answer[:start]},
                                {position: correct_answer[:end]}]
          expect(card.correct_answer?(correct_responses)).to be_true
          correct_responses = [ {position: correct_answer[:end]},
                                {position: correct_answer[:start]}]
          expect(card.correct_answer?(correct_responses)).to be_true
        end

        it 'returns false if one of the responses are outside the range of solutions' do
          incorrect_responses = [ {position: correct_answer[:end]},
                                  {position: 9000}]
          expect(card.correct_answer?(incorrect_responses)).to be_false
          incorrect_responses = [ {position: 9000},
                                  {position: correct_answer[:end]}]
          expect(card.correct_answer?(incorrect_responses)).to be_false
        end

        it 'returns false if all of the responses are outside the range of solutions' do
          incorrect_responses = [ {position: 9001},
                                  {position: 9000}]
          expect(card.correct_answer?(incorrect_responses)).to be_false
        end
      end
    end
  end

  describe 'has a tokenized html array' do
    let(:snippet) { "Test for snippets" }
    let(:card)    { FactoryGirl.create(:card_position_solution, snippet: snippet) }

    it 'returns an array of arrays' do
      expect(card.tokenized_snippet[0]).to be_an(Array)
    end

    it 'returns a tokenized array' do
      expect(card.tokenized_snippet[0][0]).to include("Test")
      expect(card.tokenized_snippet[0][0]).to_not include("for")
    end
  end

end
