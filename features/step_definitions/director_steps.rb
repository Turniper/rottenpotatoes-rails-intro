Given(/^the following movies exist:$/) do |movies_table|
  #table is a Cucumber::Ast::Table
  movies_table.hashes.each do |movie|
  Movie.create!(movie)
  end
end

Then /the director of "(.*)" should be "(.*)"/ do |m1, m2|
  Movie.find_by_title(m1).director.should == m2
end
