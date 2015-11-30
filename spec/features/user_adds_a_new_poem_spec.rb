require "spec_helper"

feature "user adds a poem to their list" do
  scenario "successfully adds poem" do
    visit "/new_poem"
    fill_in "Enter New Yorker Poem URL", with: "http://www.newyorker.com/magazine/2015/11/30/major-to-minor"
    click_button "Add Poem"

    expect(page).to have_link("Major to Minor")
  end

  scenario "submit form without url" do
    visit "/new_poem"
    click_button "Add Poem"

    expect(page).to have_content("Please include link from New Yorker Magazine (www.newyorker.com/magazines/poems)")
  end
end
