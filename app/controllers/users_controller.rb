class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[show]
  before_action :resume_session, only: %i[show]
  before_action :set_user, only: %i[show toggle_status]
  before_action :check_inactive_user, only: %i[show]
  before_action :require_admin, only: %i[ toggle_status ]

  def show; end

  def toggle_status
    @user.toggle_status!
    @user.sessions.destroy_all
    redirect_to user_path(@user), notice: t(".success")
  end

  private

  def set_user
    @user = User.unscoped.find(params[:id])
  end

  def check_inactive_user
    redirect_to root_path if @user.inactive? && (Current.user&.regular? || !Current.user)
  end

  def require_admin
    redirect_to root_path, alert: t(".unauthorized") unless Current.user&.admin?
  end
end
