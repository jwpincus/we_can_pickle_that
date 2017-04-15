require 'rails_helper'

feature "when a user visits their orders page" do
  context "a user has no orders" do
    scenario "a user sees the empty message" do
      user = create(:user)

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      visit orders_path

      expect(page).to have_content("Past Orders")
      expect(page).to have_content("You don't have any orders yet.")
    end
  end
  context "a user has many orders" do
    scenario "a user sees their orders" do
      order = create(:order_with_many_items)
      item1 = order.items.first
      user = order.user
      date = DateTime.now.strftime("%A %B %e, %Y, %l:%M %p")

      allow_any_instance_of(ApplicationController)
        .to receive(:current_user)
        .and_return(user)

      visit orders_path

      within("table.table") do
        expect(page).to have_link(order.id)
        click_on order.id
      end

      expect(current_path).to eq(order_path(order))
      expect(page).to have_content(item1.title)
      expect(page).to have_content(item1.description)
      expect(page).to have_content(item1.price)

      page.has_selector?(:xpath, '/html/body/div[2]/div/table/tbody/tr[2]/td[4]')   #
      expect(page).to have_content("Total Price: $#{order.total_price}")
      expect(page).to have_content("Purchase Date: #{date}")
      expect(page).to have_link(item1.title, href: item_path(item1))
      expect(page).to have_css("img[src*='#{item1.image_url}']")

      expect(page).to have_content("Current Status: ordered on #{date}")
    end
  end
end
