# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  page.body.match(/#{e1}.*?#{e2}/)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/,\s*/).each do |rating|
    step %Q{I #{uncheck}check "ratings_#{rating}"}
  end
end

# Avoid having to list all ratings
When /I (un)?check all ratings/ do |uncheck|
  rating_list = Movie.all_ratings.join(', ')
  step %Q{I #{uncheck}check the following ratings: #{rating_list}}
end

# Avoid having to list all movies
Then /I should see all of the movies/ do
  # Number of table rows
  rows = all("table#movies > tbody > tr").length

  # TODO undefined method `should' for Fixnum (NoMethodError)
  # Fall back to using MiniTest assertion
  #rows.should == Movie.count
  assert_equal Movie.count, rows
end

Then /movies are sorted alphabetically/ do
  titles = all("table#movies > tbody > tr > td:nth-child(1)").map {
    |element|
    element.text
  }

  # Inefficient but works.
  # Note string compare is what we want.
  assert_equal titles, titles.sort
end

Then /movies are sorted by release date/ do
  dates = all("table#movies > tbody > tr > td:nth-child(3)").map {
    |element|
    element.text
  }

  # Inefficient but works.
  # Note string compare works for standard representation of date as
  # 1992-11-25 00:00:00 UTC
  assert_equal dates, dates.sort
end
