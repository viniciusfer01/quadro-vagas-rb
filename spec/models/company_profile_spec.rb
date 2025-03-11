require 'rails_helper'

RSpec.describe CompanyProfile, type: :model do
  describe '#valid' do
    context '#presence' do
      it { should validate_presence_of(:name)  }
      it { should validate_presence_of(:website_url)  }
      it { should validate_presence_of(:contact_email)  }
      it { should have_one_attached(:logo)  }
    end

    context '#comparison_with_user_email' do
      it 'should not be equal to the user email' do
        user = create(:user, email_address: 'not_allowed@email.com')
        company_profile = build(:company_profile, contact_email: 'not_allowed@email.com', user: user)

        expect(company_profile).not_to be_valid
      end
    end

    context "#user_uniqueness" do
      it 'should allow only one company profile per user' do
        user = create(:user)
        create(:company_profile, user: user)
        invalid_company_profile = build(:company_profile, user: user)

        expect(invalid_company_profile).to be_invalid
      end
    end
  end

  describe '#format' do
    context 'email format' do
      it { should allow_value('user@example.com').for(:contact_email) }

      it { should_not allow_value('invalid@email').for(:contact_email) }
    end

    context 'logo content_type' do
      it 'should accept png images' do
        company_profile = build(:company_profile)
        company_profile.logo.attach(io: File.open('spec/support/files/logo.png'), filename: 'logo.png', content_type: 'image/png')

        expect(company_profile).to be_valid
      end

      it 'should accept jpeg images' do
        company_profile = build(:company_profile)
        company_profile.logo.attach(io: File.open('spec/support/files/logo.jpeg'), filename: 'logo.jpeg', content_type: 'image/jpeg')

        expect(company_profile).to be_valid
      end

      it 'should accept jpg images' do
        company_profile = build(:company_profile)
        company_profile.logo.attach(io: File.open('spec/support/files/logo.jpg'), filename: 'logo.jpg', content_type: 'image/jpg')

        expect(company_profile).to be_valid
      end

      it 'should not accept other formats' do
        company_profile = build(:company_profile)
        company_profile.logo.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')

        expect(company_profile).not_to be_valid
      end
    end
  end
end
