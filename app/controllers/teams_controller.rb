class TeamsController < ApplicationController
  before_action :set_team, only: [:edit, :update, :destroy]

  def index
    @teams = Team.all.order(points: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @teams, status: :ok }
    end
  end

  def new
    @team = Team.new
  end

  def edit
  end

  def create
    @team = Team.new(team_params)

    respond_to do |format|
      if @team.save
        format.html { redirect_to root_path, notice: 'Team was successfully created.' }
        format.json { render :show, status: :created, location: @team }
      else
        format.html { render :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to root_path, notice: 'Team was successfully updated.' }
        format.json { render :show, status: :ok, location: @team }
      else
        format.html { render :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to teams_url, notice: 'Team was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def reset_stats
    Match.destroy_all
    Team.clear_stats!
    redirect_to root_path
  end

  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name, :points, :won, :lost, :draw, :goal_diff)
  end
end
