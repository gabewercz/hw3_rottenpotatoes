# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.
  flunk "Unimplemented"
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  rating_list.split(/ *, */).each do |s|
      if s=~/^all$/i then
        #puts "all"
        page.all(:css, "#ratings_form input").each do |e|
          #puts "found input #{e.text}"
          if e["type"]=~/^checkbox$/i then
            step "I #{uncheck}check \"#{e['id']}\"" 
          else
            #puts "it's not a checkbox"
          end
        end
      else
        step "I #{uncheck}check \"#{'ratings_'+s}\""   
      end
  end
end

Then /only the movies with the following ratings should be listed: (.*)/ do |rating_list|
  ratings = rating_list.split(/ *, */)
  page.all(:css, "#movies tr").each do |row|
    row_html = row.native.to_s
    if row_html =~ /<td>/m then
      row_html =~ /<td>.*<\/td>.*<td>(.*)<\/td>.*<td>.*<\/td>.*<td>.*<\/td>/m
      rating = $1.strip
      assert ratings.include?(rating), "Should not return movie with rating #{rating}"
    end 
  end
end

When /I select none of the ratings/ do
  step "I uncheck the following ratings: ALL"
end

Then /I should see all of the movies/ do
  assert page.all(:css, "#movies tr").length-1 == Movie.count, "It should be returning all the movies, but it's not"
end

Then /all ratings checkboxes should be checked/ do
  page.all(:css, "#ratings_form input").each do |e|
    if e["type"]=~/^checkbox$/i then
      assert e["checked"], "#e{'id'} should be checked" 
    end
  end
end

When /I select all ratings/ do
  step "I check the following ratings: ALL"
end

Then /I should see '(.*)' before '(.*)'/ do |first,after|
  assert page.body.index(first) < page.body.index(after) , "'#{first}' should be before '#{after}'"
end
