class Referee
  attr_accessor :score, :teams

  def initialize(result, teams)
    @score = result.split('-').map(&:to_i)
    @teams = teams
  end

  def winner
    return teams.first if score.first > score.last
    return teams.last if score.first < score.last

    nil
  end

  def looser
    return teams.first if score.first < score.last
    return teams.last if score.first > score.last

    nil
  end

  def draw?
    score.first == score.last
  end
end
