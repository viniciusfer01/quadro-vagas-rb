class ExperienceLevelsController < ApplicationController

  def index
    @experience_levels = ExperienceLevel.all
  end
  
  def new
    @experience_level = ExperienceLevel.new
  end

  def create
    @experience_level = ExperienceLevel.new(experience_level_params)
    if @experience_level.save
      redirect_to experience_levels_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def experience_level_params
    params.require(:experience_level).permit(
      :name,
      :status
    )
  end
end
