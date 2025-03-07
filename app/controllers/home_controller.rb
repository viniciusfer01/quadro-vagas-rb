class HomeController < ApplicationController
  allow_unauthenticated_access
  def index
    @job_postings = JobPosting.all
  end
end
