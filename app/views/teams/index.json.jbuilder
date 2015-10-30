json.array!(@teams) do |team|
  json.extract! team, :is, :name, :points, :won, :lost, :draw, :goal_diff
  json.url team_url(team, format: :json)
end


