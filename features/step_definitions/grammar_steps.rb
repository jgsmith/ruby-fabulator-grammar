require 'yaml'

When /^I parse the regex \((.*)\)$/ do |regex|
  @context ||= Fabulator::Expr::Context.new
  @grammar_parser ||= Fabulator::Grammar::TokenParser.new
  @rule_parser ||= Fabulator::Grammar::RuleParser.new
  @regex = @grammar_parser.parse(regex)
#  puts YAML::dump(r)
#  puts @regex.to_regex
#  pending # express the regexp above with the code you wish you had
end

Then /^I can parse the rule \((.*)\)$/ do |rule|
  @context ||= Fabulator::Expr::Context.new
  @grammar_parser ||= Fabulator::Grammar::TokenParser.new
  @rule_parser ||= Fabulator::Grammar::RuleParser.new
  @rule = @rule_parser.parse(rule)
  @rule.should_not == nil
end

Then /^I can not parse the rule \((.*)\)$/ do |rule|
  @context ||= Fabulator::Expr::Context.new
  @grammar_parser ||= Fabulator::Grammar::TokenParser.new
  @rule_parser ||= Fabulator::Grammar::RuleParser.new
  @rule = (@rule_parser.parse(rule) rescue nil)
  @rule.should == nil
end

Then /^it should match "(.*)"$/ do |str|
  str.should =~ @regex.to_regex
end

Then /^it should not match "(.*)"$/ do |str|
  str.should_not =~ @regex.to_regex
end

Then /^"(.*)" should match "(.*)"$/ do |nom, str|
  ret = @grammar.parse(@context, nom, str)
#  puts YAML::dump(ret)
  ret.should_not == nil

  @context.root = @context.root.anon_node(nil)
  if !ret.nil?
    @context.merge_data(ret)
    @context.root.roots['data'] = @context.root
#puts YAML::dump(@context.root.to_h)
  end
end

Then /^"(.*)" should not match "(.*)"$/ do |nom, str|
  @grammar.parse(@context, nom, str).should == nil
end
