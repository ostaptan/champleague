module TeamHelper

  def played(team)
    team.won + team.draw + team.lost
  end
end
