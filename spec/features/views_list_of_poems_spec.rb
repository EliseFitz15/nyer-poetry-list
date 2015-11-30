require 'spec_helper'

feature "user views favorite poems list" do
  scenario "sees poem titles linked to show pages" do
    db_connection do |conn|
      sql_query = "INSERT INTO poems (title, author, body) VALUES ($1, $2, $3)"
      data = ["Horse Piano", "Anna MacDonald", "This is where the poem would be"]
      conn.exec_params(sql_query, data)
    end

    visit "/poems"
    expect(page).to have_link("Horse Piano")
  end
end
