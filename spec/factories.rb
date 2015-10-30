FactoryGirl.define do
  factory :team do
    name      "Barca"
    points    0
    won       0
    lost      0
    draw      0
    goal_diff 0
  end

  factory :match do
    result "0-0"
    association :teams, factory: :team
  end
end
