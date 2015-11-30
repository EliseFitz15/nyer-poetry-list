require "spec_helper"

feature "user clicks on poem title and sees full poem" do
  scenario "navigates from index page" do
    db_connection do |conn|
      sql_query = "INSERT INTO poems (title, author, body) VALUES ($1, $2, $3)"
      data = ["Horse Piano", "Anna MacDonald", "The idea is you get a Central Park work horse..."]
      conn.exec_params(sql_query, data)
    end

    visit "/poems"
    click_link("Horse Piano")
    expect(page).to have_content("Horse Piano")
    expect(page).to have_content("Anna MacDonald")
    expect(page).to have_content("The idea is you get a Central Park work horse...")
  end
end
