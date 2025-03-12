require 'rails_helper'

describe 'User create experience level' do
  it 'and must be logged in', type: :request do
    post(experience_levels_path, params: { experience_level: { name: 'Junior', status: :archived } })

    expect(response).to redirect_to(new_session_path)
  end

  it 'and user must be admin', type: :request do
    user = create(:user, role: :regular)
    login_as user

    post(experience_levels_path, params: { experience_level: { name: 'Junior', status: :archived } })

    expect(response).to redirect_to(root_path)
  end

  it 'succesfully', type: :request do
    user = create(:user, role: :admin)
    login_as user

    post(experience_levels_path, params: { experience_level: { name: 'Junior', status: :archived } })

    expect(response).to redirect_to(experience_levels_path)
  end
end
