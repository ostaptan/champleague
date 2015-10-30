require 'rails_helper'

describe Match do
  let!(:team1) { FactoryGirl.create(:team) }
  let!(:team2) { FactoryGirl.create(:team) }

  context '#play' do
    it 'plays match with winner' do
      match = FactoryGirl.create(:match, teams: [team1, team2], result: '3-2').play
      expect(match.teams.first.won).to eq 1
      expect(match.teams.first.points).to eq 3
      expect(match.teams.last.lost).to eq 1
      expect(match.teams.last.points).to eq 0
    end

    it 'plays match with draw' do
      match = FactoryGirl.create(:match, teams: [team1, team2], result: '3-3').play
      expect(match.teams.first.draw).to eq 1
      expect(match.teams.first.points).to eq 1
      expect(match.teams.last.draw).to eq 1
      expect(match.teams.last.points).to eq 1
    end
  end

  context '#update_teams' do
    it 'updates teams to draw from win' do
      match = FactoryGirl.create(:match, teams: [team1, team2], result: '3-2').play
      match.update_attribute(:result, '2-2')
      expect(match.teams.first.draw).to eq 1
      expect(match.teams.last.draw).to eq 1
      expect(match.teams.first.won).to eq 0
      expect(match.teams.first.points).to eq 1
      expect(match.teams.last.points).to eq 1
    end

    it 'updates teams to win from draw' do
      match = FactoryGirl.create(:match, teams: [team1, team2], result: '2-2').play
      match.update_attribute(:result, '1-2')
      expect(match.teams.last.won).to eq 1
      expect(match.teams.first.draw).to eq 0
      expect(match.teams.last.draw).to eq 0
      expect(match.teams.first.points).to eq 0
      expect(match.teams.last.points).to eq 3
    end

    it 'updates teams to lose from win' do
      match = FactoryGirl.create(:match, teams: [team1, team2], result: '3-2').play
      match.update_attribute(:result, '2-3')
      expect(match.teams.first.lost).to eq 1
      expect(match.teams.last.lost).to eq 0
      expect(match.teams.first.won).to eq 0
      expect(match.teams.last.won).to eq 1
      expect(match.teams.first.points).to eq 0
      expect(match.teams.last.points).to eq 3
    end
  end
end
