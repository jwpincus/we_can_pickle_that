require "rails_helper"

RSpec.feature "Viewing past orders" do
  context "Authenticated user" do
    scenario "cannot see admin page" do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      visit admin_dashboard_path

      expect(page).to have_xpath("//img[@src='http://i.imgur.com/4zZv7CM.jpg']")
      expect(page).to_not have_button("View All Users")
    end
  end
end
