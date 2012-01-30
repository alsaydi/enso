require 'test/unit'

require 'core/system/load/load'
require 'core/semantics/code/visitor'
require 'core/semantics/code/internal-visitor'
require 'core/expr/code/eval'
require 'core/expr/code/render'

class ExprTest < Test::Unit::TestCase

  def test_base
    interp = Interpreter(EvalExpr)

    ex0 = Loader.load("my-expr.expr")
    assert_equal(6, interp.eval(ex0))
  end

  def test_internal
    interp = Interpreter(InternalVisitor("eval", EvalExprIntern))

    ex0 = Loader.load("my-expr.expr")
    assert_equal(6, interp.visit(ex0))
  end

=begin
  def test_add_types
    s = union(Loader.load('expr-vars.schema'), Loader.load('expr.schema'))
    g = union(Loader.load('expr-vars.grammar'), Loader.load('expr.grammar'))
    ex1 = Loader.load_with_models("my-expr-vars.expr", g, s)
  end
=end
=begin
  def test_add_actions
    #load an expression and display it
    ex0 = Loader.load("my-expr.expr")

    #add actions to the expression
    f = ManagedData::Factory.new(Loader.load("expr.schema"))
    f.add_interp(EvalExpr)
    assert_equal(Copy(f,ex0).eval1, 6)

    f.add_interp(RenderExpr)
    assert_equal(Copy(f,ex0).render, "1 + 2 + 3")
  end

  def test_add_types
    s = union(Loader.load('expr-vars.schema'), Loader.load('expr.schema'))
    g = union(Loader.load('expr-vars.grammar'), Loader.load('expr.grammar'))
    ex1 = Loader.load_with_models("my-expr-vars.expr", g, s)

    fv = ManagedData::Factory.new(s)
    fv.add_interp(EvalExpr)
    fv.add_interp(RenderExpr)
    fv.add_interp(Vars)

    assert_equal(Copy(fv, ex1).eval1({'a'=>5}), 22)
    assert_equal(Copy(fv, ex1).render, "a + 17")
  end

  def test_generic
    #load an expression and display it
    ex0 = Loader.load("my-expr.expr")

    f = ManagedData::Factory.new(Loader.load("expr.schema"))
    f.add_interp(RenderExpr)
    f.add_interp(Wrap)
    assert_equal("((1) + ((2) + (3)))", Copy(f,ex0).wrap[:render])
  end
=end
end
