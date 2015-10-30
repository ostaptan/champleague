class Scheduler
  include Predictable

  attr_reader :teams, :combinations, :current_week

  def initialize
    @teams = Team.all
    @combinations = @teams.combination(2).to_a
    @current_week = Match.last.nil? ? -1 : Match.last.week
  end

  def play_next_week
    week_games = []

    @current_week += 1
    return unless current_week < combinations_by_weeks.count

    combinations_by_weeks[current_week].each do |teams|
      week_games << Match.create(teams: teams, result: predicted_result(teams), week: current_week).play.as_json(include: :teams)
    end

    week_games
  end

  def play_all_weeks
    games = []

    @current_week += 1
    return unless current_week == 0

    combinations_by_weeks.each_with_index do |gameset, week|
      week_games = []
      gameset.each do |teams|
        week_games << Match.create(teams: teams, result: predicted_result(teams), week: week).play.as_json(include: :teams)
      end
      games << week_games
    end

    games
  end

  def combinations_by_weeks
    weeks = []
    combos = combinations.clone

    while combos.size > 0 do
      week = [combos.pop, combos.shift]
      weeks << week
    end

    weeks
  end

end



