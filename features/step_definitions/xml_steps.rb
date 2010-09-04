Given /the grammar/ do |doc_xml|
  @context ||= Fabulator::Expr::Context.new

  if @grammar.nil?
    @grammar = Fabulator::Grammar::Actions::Grammar.new.compile_xml(doc_xml, @context)
  else
    @grammar.compile_xml(doc_xml, @context)
  end

#  puts YAML::dump(@grammar)
end

