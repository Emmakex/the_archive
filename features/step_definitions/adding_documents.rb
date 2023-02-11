require 'cucumber/rspec/doubles'

Given('there is a user named {string}') do |string|
  User.create!(name: string)
end

Given('I am logged in as {string}') do |string|
  @current_user = User.find_by!(name: string)
  expect(@current_user).to be_present
  allow(Current).to receive(:user).and_return(@current_user)
end

When('I go to the {string} page') do |string|
  visit string.downcase.gsub(' ', '-')
end

When('I fill the form with') do |table|
  table.raw.each do |field, value|
    @title = value if field == 'Title'
    fill_in field, with: value
  end
end

When('I press {string}') do |string|
  click_button(string)
end

Then('the document is added to the archive') do
  @document = Document.find_by!(title: @title)
  expect(@document).to be_present
end

Then('the document identifier is {string}') do |string|
  expect(@document.identifier).to eq(string)
end

When('I attach the file {string} to {string}') do |file, field|
  attach_file(field, 'features/fixtures/' + file)
end

Then('the attachment is added to the archive') do
  expect(@document.attachment).to be_attached
end

Given('a document with the identifier {string} exists') do |identifier|
  location = Location.create!(name: identifier.split('-').first.titleize)
  Document.create!(created_by: User.create!(name: 'Test User'), identifier:, location:)
  # pending # Write code here that turns the phrase above into concrete actions
end
