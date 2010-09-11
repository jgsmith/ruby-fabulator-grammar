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

#  puts YAML::dump(@library)
end

