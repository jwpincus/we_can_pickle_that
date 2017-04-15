require 'rails_helper'

RSpec.feature "Admin Dashboard"do
  before :each do
    @user = create(:user)
    @user.update_attributes(role: 'admin')
    # order1, order2, order3, order4 = create_list(:order_with_many_items, 4)
    statii = ["ordered", "paid", "completed", "cancelled"]
    orders = create_list(:order_item, 4)
    index = 0
    orders.each do |order|
      order.order.update(status: statii[index])
      index += 1
    end
    visit login_path
    fill_in "session[email]", with: @user.email
    fill_in "session[password]", with: @user.password
    click_button "Log In"
  end
  scenario "shows order information" do
    visit admin_dashboard_path
    expect(page).to have_css("table#ordered tr", :count=>1)
    expect(page).to have_css("table#paid tr", :count=>1)
    expect(page).to have_css("table#completed tr", :count=>1)
    expect(page).to have_css("table#cancelled tr", :count=>1)
    expect(page).to have_content("Ordered: 1")
    expect(page).to have_content("Paid: 1")
    expect(page).to have_content("Cancelled: 1")
    expect(page).to have_content("Completed: 1")
  end
  scenario "change ordered to paid" do
    visit admin_dashboard_path
    expect(page).to have_content("Paid: 1")
    within('table#ordered') do
      click_button("mark as paid")
    end
    expect(page).to have_content("Paid: 2")
  end
  scenario "change ordered to cancelled" do
    visit admin_dashboard_path
    expect(page).to have_content("Cancelled: 1")
    within('table#ordered') do
      click_button("cancel")
    end
    expect(page).to have_content("Cancelled: 2")
  end
  scenario "change paid to cancelled" do
    visit admin_dashboard_path
    expect(page).to have_content("Cancelled: 1")
    within('table#paid') do
      click_button("cancel")
    end
    expect(page).to have_content("Cancelled: 2")
  end
  scenario "change paid to completed" do
    visit admin_dashboard_path
    expect(page).to have_content("Completed: 1")
    within('table#paid') do
      click_button("mark as completed")
    end
    expect(page).to have_content("Completed: 2")
  end
end


# - I can click on "mark as completed" on orders that are "paid"
