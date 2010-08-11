require 'yaml'

When /^I parse the regex \((.*)\)$/ do |regex|
  @context ||= Fabulator::Expr::Context.new
  @grammar_parser ||= Fabulator::Grammar::Parser.new
  @regex = @grammar_parser.parse(regex, @context)
#  puts YAML::dump(r)
#  puts @regex.to_regex
#  pending # express the regexp above with the code you wish you had
end

Then /^it should match "(.*)"$/ do |str|
  str.should =~ @regex.to_regex
end

Then /^it should not match "(.*)"$/ do |str|
  str.should_not =~ @regex.to_regex
end
