

require 'test/unit'

require 'core/grammar/code/parse'
require 'core/grammar/code/layout'

require 'core/system/boot/grammar_grammar'
require 'core/instance/code/instantiate'
require 'core/diff/code/diff'
require 'core/schema/code/factory'

class ParseTest < Test::Unit::TestCase

  GRAMMAR_GRAMMAR = 'core/grammar/models/grammar.grammar'
  SCHEMA_GRAMMAR = 'core/schema/models/schema.grammar'
  SCHEMA_SCHEMA = 'core/schema/models/schema.schema'
  
  def test_parse_render
    boot = GrammarGrammar.grammar
    grammar1 = Parse.load_file(GRAMMAR_GRAMMAR, boot, GrammarSchema.schema)
    s = ''
    DisplayFormat.print(GrammarGrammar.grammar, grammar1, 80, s)
    grammar2 = Parse.load(s, GrammarGrammar.grammar, GrammarSchema.schema)
    assert_equal([], diff(grammar1, grammar2))
  end


end
