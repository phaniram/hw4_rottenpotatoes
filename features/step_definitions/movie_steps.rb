# Add a declarative step here for populating the DB with movies.


Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
     Movie.create!(movie)
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
  end
  #assert movies_table.hashes.size == Movie.all.count
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /^the director of "(.*)" should be "(.*)"$/ do |title,director|
    assert  page.find(:xpath,'//*[@id="details"]/li[3]').text.include? director
end


Then /I should see "(.*)" before "(.*)"/ do |e1, e2|

  #  ensure that that e1 occurs before e2.
  #  page.content  is the entire content of the page as a string.  

  titles = page.all("table#movies tbody#movielist tr td[1]").map { |t| t.text }
  assert titles.index(e1) < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  rating_list.split(",").each do |field|
    field = field.strip
    if uncheck == "un"
       step %Q{I uncheck "ratings_#{field}"}
       step %Q{the "ratings_#{field}" checkbox should not be checked}
    else
      step %Q{I check "ratings_#{field}"}
      step %Q{the "ratings_#{field}" checkbox should be checked}
    end
  end
end

Then /^I should(nt)? see the following ratings: (.*)/ do |chk, rating_list|
  ratings = page.all("table#movies tbody#movielist tr  tr td[2]").map! {|t| t.text}
  rating_list.split(",").each do |field|
    if chk=="not"
      assert ratings.include?(field.strip)
    else
      assert !ratings.include?(field.strip)
    end
end
end

Then /^I should see (all|none) of the movies$/ do |sel|
  if(sel.eql?("all"))
    #page.has_css?("table#movies tr", :count => 4)
    assert page.all("table#movies tbody#movielist tr").count ==10
  else
    assert page.all("table#movies tbody#movielist tr").count ==0
  end
end