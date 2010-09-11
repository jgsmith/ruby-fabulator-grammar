Given /the grammar/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new

  if @grammar.nil?
    @grammar = Fabulator::Grammar::Actions::Grammar.new
    @grammar.compile_xml(doc_xml, @context)
  else
    @grammar.compile_xml(doc_xml, @context)
  end

#  puts YAML::dump(@grammar)
end

Given /the library/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new

  if @library.nil?
    @library = Fabulator::Lib::Lib.new
    @library.compile_xml(doc_xml, @context)
  else
    @library.compile_xml(doc_xml, @context)
  end

  @library.register_library
end

Given /the statemachine/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new

  if @sm.nil?
    @sm = Fabulator::Core::StateMachine.new
    @sm.compile_xml(doc_xml)
  else
    @sm.compile_xml(doc_xml)
  end
  @sm.init_context(@context)
end

When /I run it with the following params:/ do |param_table|
  params = { }
  param_table.hashes.each do |hash|
    params[hash['key']] = hash['value']
  end
  @sm.run(params)
end

Then /it should be in the '(.*)' state/ do |s|
  @sm.state.should == s
end

