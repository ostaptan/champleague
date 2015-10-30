require 'rails_helper'

describe Team do
  context 'set results' do
    let(:team) { FactoryGirl.create(:team) }

    it '#won!' do
      team.won!([1, 0])
      expect(team.won).to eq 1
      expect(team.points).to eq 3
    end

    it '#lost!' do
      team.lost!([0, 2])
      expect(team.lost).to eq 1
      expect(team.points).to eq 0
    end

    it '#draw!' do
      team.draw!([1, 1])
      expect(team.draw).to eq 1
      expect(team.points).to eq 1
    end
  end

  context 'update statistics' do
    let!(:team1) { FactoryGirl.create(:team) }
    let!(:team2) { FactoryGirl.create(:team) }
    let!(:teams) { [team1, team2] }

    it '#update_winner!' do
      referree_was = Referee.new('1-0', teams)
      referree_is = Referee.new('2-3', teams)
      referree_is.winner.update_winner!(referree_was, referree_is)
      expect(team2.won).to eq 1
      expect(team2.points).to eq 3
    end

    it '#update_looser!' do
      referree_was = Referee.new('1-0', teams)
      referree_is = Referee.new('2-3', teams)
      referree_is.looser.update_looser!(referree_was, referree_is)
      expect(team1.lost).to eq 1
      expect(team1.points).to eq 0
    end

    it '#update_with_draw!' do
      referree_was = Referee.new('1-0', teams)
      referree_is = Referee.new('2-2', teams)
      team1.update_with_draw!(referree_was, referree_is)
      team2.update_with_draw!(referree_was, referree_is)
      expect(team1.draw).to eq 1
      expect(team2.draw).to eq 1
      expect(team1.points).to eq 1
      expect(team2.points).to eq 1
    end

    it '#update_goal_diff! from draw' do
      team1.update_goal_diff!([2,2], [0,4])
      expect(team1.goal_diff).to eq 4
    end

    it '#update_goal_diff! from win' do
      team1.update_goal_diff!([3,2], [0,4])
      expect(team1.goal_diff).to eq 3
    end

    it '#update_goal_diff! from lose' do
      team1.update_goal_diff!([2,4], [0,4])
      expect(team1.goal_diff).to eq 2
    end
  end
end
