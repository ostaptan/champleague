class Team < ActiveRecord::Base
  has_and_belongs_to_many :matches

  validates_presence_of :name, :points

  WIN = 3
  DRAW = 1

  def won!(goals)
    self.transaction do
      self.points += WIN
      self.won += 1
      self.goal_diff += calc_goal_diff(goals)
      self.save!
    end
  end

  def lost!(goals)
    self.transaction do
      self.lost += 1
      self.goal_diff += calc_goal_diff(goals)
      self.save!
    end
  end

  def draw!(goals)
    self.transaction do
      self.points += DRAW
      self.draw += 1
      self.save!
    end
  end

  def self.clear_stats!
    self.all.each do |team|
      team.transaction do
        team.points = 0
        team.lost = 0
        team.won = 0
        team.draw = 0
        team.goal_diff = 0
        team.save!
      end
    end
  end

  def update_winner!(referee_was, referee_is)
    self.transaction do
      self.won += 1
      self.points += WIN

      if referee_was.draw?
        self.draw -= 1 if self.draw > 0
        self.points -= DRAW if self.points >= DRAW
      else
        self.lost -= 1 if self.lost > 0
      end
      self.save!

      update_goal_diff!(referee_was.score, referee_is.score)
    end
  end

  def update_looser!(referee_was, referee_is)
    self.transaction do
      self.lost += 1

      if referee_was.draw?
        self.draw -= 1 if self.draw > 0
        self.points -= DRAW if self.points >= DRAW
      else
        self.won -= 1 if self.won > 0
        self.points >= WIN ? self.points -= WIN : self.points = 0
      end
      self.save!

      update_goal_diff!(referee_was.score, referee_is.score)
    end
  end

  def update_with_draw!(referee_was, referee_is)
    self.transaction do
      self.draw += 1

      if referee_was.looser == self
        self.lost -= 1 if self.lost > 0
      else
        self.won -= 1 if self.won > 0
        self.points >= WIN ? self.points -= WIN : self.points = 0
      end
      self.points += DRAW
      self.save!

      update_goal_diff!(referee_was.score, referee_is.score)
    end
  end

  def update_goal_diff!(goals_was, goals_is)
    self.transaction do
      self.goal_diff -= calc_goal_diff(goals_was)
      self.goal_diff += calc_goal_diff(goals_is)
      self.save!
    end
  end

  private

  def calc_goal_diff(goals)
    goals.sort.last - goals.sort.first
  end
end
