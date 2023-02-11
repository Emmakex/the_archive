Given('there are the following documents in the archive') do |table|
  user = User.find_or_create_by!(name: 'Test User')
  table.symbolic_hashes.each do |data|
    data => {title:, location:, tags:}
    location_record = Location.find_or_create_by!(name: location)
    tag_records = tags.split(',').map { Tag.find_or_create_by!(name: _1.strip) }
    Document.create!(title:, location: location_record, tags: tag_records, created_by: user)
  end

  expect(Document.count).to eq(table.hashes.size)
end

Given('I go to the document list page') do
  visit documents_path
end

Then('I should see the following documents') do |table|
  table.symbolic_hashes.each do |data|
    data => {title:, location:, tags:}
    expect(page).to have_content(title)
    find('div.document', text: title).tap do |row|
      expect(row).to have_content(location)
      expect(row).to have_content(tags)
    end
  end
  # table is a Cucumber::MultilineArgument::DataTable
  # pending # Write code here that turns the phrase above into concrete actions
end

When('I click on {string}') do |string|
  click_link(string)
end
