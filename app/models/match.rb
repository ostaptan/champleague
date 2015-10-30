class Match < ActiveRecord::Base
  has_and_belongs_to_many :teams

  validates_presence_of :result

  after_update :update_teams

  def play
    referee = Referee.new(self.result, self.teams)

    referee.winner.won!(referee.score) if referee.winner
    referee.looser.lost!(referee.score) if referee.looser

    self.teams.each { |team| team.draw!(referee.score) } if referee.draw?

    self
  end

  def update_teams
    referee_decision_was = Referee.new(self.result_was, self.teams)
    referee_decision_is = Referee.new(self.result, self.teams)

    # updates from draw to draw
    if referee_decision_was.draw? && referee_decision_is.draw?
      referee_decision_is.winner.update_goal_diff!(referee_decision_was.score, referee_decision_is.score)
      return
    end

    # updates from win/lose to draw
    if referee_decision_was.winner && referee_decision_is.draw?
      self.teams.each { |team| team.update_with_draw!(referee_decision_was, referee_decision_is) }
      return
    end

    # updates from draw to win/lose
    if referee_decision_was.draw? && referee_decision_is.winner
      referee_decision_is.winner.update_winner!(referee_decision_was, referee_decision_is)
      referee_decision_is.looser.update_looser!(referee_decision_was, referee_decision_is)
      return
    end

    # updates from win/lose to lose/win
    if referee_decision_was.winner && referee_decision_is.winner
      referee_decision_is.winner.update_winner!(referee_decision_was, referee_decision_is)
      referee_decision_is.looser.update_looser!(referee_decision_was, referee_decision_is)
      return
    end
  end
end
