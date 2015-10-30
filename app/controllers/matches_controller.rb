class MatchesController < ApplicationController
  before_action :set_match, only: [:update]

  def update
    respond_to do |format|
      if @match.update_attribute(:result, match_params[:result])
        format.json { render json: @match, status: :ok }
      else
        format.json { render json: @match.errors, status: :unprocessable_entity }
      end
    end
  end

  def play
    @results = [scheduler.play_next_week]
    @predictions = scheduler.predict_next_week

    respond_to do |format|
      format.json { render json: {results: @results, predicts: @predictions}.to_json, status: :ok}
    end
  end

  def play_all
    @results = scheduler.play_all_weeks

    respond_to do |format|
      format.json { render json: @results.to_json, status: :ok}
    end
  end

  def reset_stats
    Match.destroy_all
    Team.clear_stats!
    redirect_to root_path
  end

  private

  def scheduler
    @scheduler ||= Scheduler.new
  end

  def set_match
    @match = Match.find(params[:id])
  end

  def match_params
    params.require(:match).permit(:result)
  end
end

