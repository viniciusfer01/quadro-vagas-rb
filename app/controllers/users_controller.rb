class UsersController < ApplicationController
  before_action :set_user, only: %i[show toggle_status]
  before_action :require_admin, only: %i[ toggle_status ]

  def show
    redirect_to root_path, alert: "Access denied" if !@user.active? && !Current.user&.admin?
  end

  def toggle_status
    @user.toggle_status!
    redirect_to user_path(@user), notice: t(".success")
  end

  private

  def set_user
    @user = User.unscoped.find(params[:id])
  end

  def require_admin
    redirect_to root_path, alert: "Access denied" unless Current.user&.admin?
  end
end
