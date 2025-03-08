class HomeController < ApplicationController
  allow_unauthenticated_access
  def index
    @job_postings = JobPosting.all
  end

  def search
    if params[:title].present?
      @job_postings = JobPosting.search_jobs(params[:title])
      return render :index
    end
    redirect_to root_path, alert: t(".alert")
  end
end
