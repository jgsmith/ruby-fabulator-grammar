Given /the grammar/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new
  @compiler ||= Fabulator::Compiler.new

  if @grammar.nil?
    @grammar = @compiler.compile(doc_xml)
  else
    @grammar.compile_xml(doc_xml, @context)
  end

#  puts YAML::dump(@grammar)
end

Given /the library/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new
  @compiler ||= Fabulator::Compiler.new

  if @library.nil?
    @library = @compiler.compile(doc_xml)
  else
    @library.compile_xml(doc_xml, @context)
  end

  @library.register_library
end

Given /the statemachine/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new
  @compiler ||= Fabulator::Compiler.new

  if @sm.nil?
    @sm = @compiler.compile(doc_xml)
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

