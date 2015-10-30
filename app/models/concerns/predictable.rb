module Predictable
  def predict_next_week
    prediction = {}
    @teams.map do |team|
      win_percent = (team.points * 100)/average_teams_points.to_f
      prediction[team.name] = win_percent.round(2)
    end

    prediction
  end

  def average_teams_points
    @teams.map(&:points).inject(&:+)
  end

  def predicted_result(teams)
    return random_result if current_week == 0

    case predict_next_week[teams.first.name] <=> predict_next_week[teams.last.name]
    when 1
      "#{rand(2..4)}-#{rand(0..3)}"
    when -1
      "#{rand(0..3)}-#{rand(2..4)}"
    when 0
      "#{rand(2)}-#{rand(2)}"
    end
  end

  def random_result
    "#{rand(4)}-#{rand(4)}"
  end
end
