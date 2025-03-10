class CompanyProfilesController < ApplicationController
  def index
    @company_profile = Current.user.company_profile if Current.user.company_profile.present?
  end

  def new
    redirect_to_root_if_user_already_has_a_company_profile
    return if performed?

    @company_profile = CompanyProfile.new
  end

  def create
    redirect_to_root_if_user_already_has_a_company_profile
    return if performed?

    @company_profile = Current.user.build_company_profile(company_profile_params)

    if @company_profile.save
      redirect_to company_profiles_path, notice: t(".success")
    else
      flash.now[:alert] = t(".failure")
      render :new, status: :unprocessable_entity
    end
  end

  private
  def redirect_to_root_if_user_already_has_a_company_profile
    redirect_to root_path, alert: t(".user_already_has_a_company_profile") if Current.user.company_profile.present?
  end

  def company_profile_params
    params.require(:company_profile).permit(:name, :website_url, :contact_email, :logo)
  end
end
