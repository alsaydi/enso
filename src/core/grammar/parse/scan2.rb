
require 'strscan'
require 'core/grammar/tools/cyclicmap'

class Scan2
  SYMBOL = "[\\\\]?[a-zA-Z_][a-zA-Z_0-9]*"

  TOKENS =  {
    sym: Regexp.new(SYMBOL),
    int: /[-+]?[0-9]+(?![.][0-9]+)/,
    str: Regexp.new("\"(\\\\.|[^\"])*\"".encode('UTF-8')),
    real: /[-+]?[0-9]*\.[0-9]+([eE][-+]?[0-9]+)?/
  }
  
  LAYOUT = /(\s*(\/\/[^\n]*\n)?)*/

  def initialize(grammar, source)
    init_literals(grammar)
    @source = source
    @scanner = StringScanner.new(@source)
  end

  def with_token(kind, ci)
    @scanner.pos = ci
    tk, kind = scan_token(kind)
    if tk then
      # keywords are reserved
      return if @keywords.include?(tk)
      yield @scanner.pos, unescape(tk, kind)
    end
  end

  def lookahead(pat, ci)
    @scanner.pos = ci
    @scanner.scan(pat)
  end

  def with_literal(lit, ci)
    # cache literal regexps as we go
    @lit_res[lit] ||= Regexp.new(Regexp.escape(lit))
    @scanner.pos = ci
    val = @scanner.scan(@lit_res[lit])
    if val then
      yield @scanner.pos, val
    end
  end

  def with_layout(ci)
    @scanner.pos = ci
    ws = @scanner.scan(LAYOUT)
    yield @scanner.pos, ws
  end

  def self.collect_keywords(grammar)
    CollectKeywords.run(grammar)
  end

  # TODO: remove dependency on CyclicCollectShy
  class CollectKeywords < CyclicCollectShy
    def Lit(this, accu)
      accu << this.value if this.value.match(SYMBOL)
    end
  end

  private

  def init_literals(grammar)
    @keywords = CollectKeywords.run(grammar)
    @lit_res = {}
    # \ also has a follow restriction
    (['\\'] + @keywords).each do |kw|
      @lit_res[kw] = Regexp.new(Regexp.escape(kw) + "(?![a-zA-Z_$0-9])")
    end
  end


  def unescape(tk, kind)
    if kind == 'str' then
      tk[1..-2] # todo: backslash blues
    elsif kind == 'sym' then
      tk.sub(/^\\/, '')
    else
      tk
    end
  end

  def scan_token(kind)
    if kind == 'atom' then
      TOKENS.each_key do |type|
        tk = @scanner.scan(TOKENS[type])
        # return the token with its concrete (i.e. non-atom) type
        return tk, type.to_s if tk 
      end
      return nil
    end
    tk = @scanner.scan(TOKENS[kind.to_sym])
    return tk, kind
  end

end
