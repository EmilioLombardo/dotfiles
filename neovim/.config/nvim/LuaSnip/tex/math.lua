-- LuaSnip shorthand variables (ls, s, sn, t, i, f, d, fmt, fmta, rep) {{{
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep-- }}}

local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1 -- Requires the VimTeX plugin
end

local get_visual = function(args, parent)-- {{{
  -- When `LS_SELECT_RAW` is populated with a visual selection, the function
  -- returns an insert node whose initial text is set to the visual selection.
  -- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert
  -- node.
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end-- }}}

-- Snippet generator: autoexpand in math zone
-- default opts: { wordTrig = false, regTrig = false }
-- NOTE: opts.regTrig only works for using a lua pattern to match a single
-- character at the beginning of the trigger
local function autoexpand(trigger, text, opts)-- {{{
  if opts then
    opts.regTrig = opts.regTrig or false
    opts.wordTrig = opts.wordTrig or false
    opts.name = opts.name or text
    opts.dscr = opts.dscr or nil
  else
    opts = { regTrig=false, wordTrig=false, name=text }
  end
  if opts.regTrig then
    return s(
      {
        trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=in_mathzone,
        wordTrig=false, regTrig=opts.regTrig
      },
      { f(function(_, snip) return snip.captures[1] end), t(text), }
    )
  end

  return s({trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=in_mathzone,
    wordTrig=opts.wordTrig}, { t(text), })
end-- }}}

-- Snippet generator: \begin{...}...\end{...} in mathzone
-- default opts: { math_only = true, multiline = false }
local function snip_begin_env(trigger, env_name, opts)-- {{{
  local default_name = "\\begin{"..env_name.."}"
  local default_dscr = "(math) New "..env_name.." environment in math zone"
  if opts then
    opts.math_only = opts.math_only or true -- only trigger in mathzone
    opts.multiline = opts.multiline or false -- put \begin & \end on one line by default
    opts.name = opts.name or default_name
    opts.dscr = opts.dscr or default_dscr
  else
    opts = { math_only=true, multiline=false, name=default_name, dscr=default_dscr}
  end

  local text
  if opts.multiline then
    text = string.format([[
    \begin{%s}
        <>
    \end{%s}
    ]], env_name, env_name)
  else
    text = string.format("\\begin{%s}<>\\end{%s}", env_name, env_name)
  end

  local cond = opts.math_only and nil or in_mathzone

  return s({trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", wordTrig=false, condition=cond},
      fmta(text, { d(1, get_visual), }) )
end-- }}}

-- Snippet generator: for any text with exactly one node, indicated with <>.
-- Uses d(1, get_visual) as the snippet node, meaning it can wrap LS_SELECT_RAW.
-- default opts: { wordTrig = false, regTrig = false }
-- NOTE: opts.regTrig only works for using a lua pattern to match a single
-- character at the beginning of the trigger
local function snip_command(trigger, text, opts)-- {{{
  if opts then
    opts.regTrig = opts.regTrig or false
    opts.wordTrig = opts.wordTrig or false
    opts.name = opts.name or string.gsub(text, "<>", "...")
    opts.dscr = opts.dscr or nil
  else
    opts = { name=string.gsub(text, "<>", "..."), regTrig=false, wordTrig=false, }
  end

  local _, count = string.gsub(text, "<>", "")
  if count ~= 1 then
    error("snip_command: text must contain exactly one <>")
  end

  if opts.regTrig then
    if opts.wordTrig then
      error("regTrig and wordTrig should not both be set to true")
    end
    return s(
      {trig=trigger, name=opts.name, dscr=opts.dscr, regTrig=true, wordTrig=false, condition=in_mathzone, snippetType="autosnippet"},
      fmta(
        "<>"..text,
        { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }
      )
    )
  end
  return s(
    {trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=in_mathzone, wordTrig=opts.wordTrig},
    fmta( text, { d(1, get_visual), })
  )
end-- }}}

return {
  -- [[ Common commands ]] (frac, sum, int, sin, norm, min ...) {{{

  -- ff -> \frac{}{} {{{
  s({trig="([^%a])ff", name="\\frac{}{}", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\frac{<>}{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- ss -> \sum_{}^{} {{{
  s({trig="([^%a])ss", name="\\sum_{}^{}", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\sum_{<>}^{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- pp -> \prod_{}^{} {{{
  s({trig="([^%a])pp", name="\\prod_{}^{}", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\prod_{<>}^{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- lms -> \limits_{}^{} {{{
  s({trig="([^%a])lms", name="\\limits_{}^{}", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\limits_{<>}^{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- sU -> \bigcup\limits_{}^{} {{{
  s({trig="([^%a])sU", name="\\bigcup\\limits_{}^{}", dscr="indexed union of sets", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\bigcup\\limits_{<>}^{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- sS -> \bigcap\limits_{}^{} {{{
  s({trig="([^%a])sS", name="\\bigcap\\limits_{}^{}", dscr="indexed intersection of sets", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\bigcap\\limits_{<>}^{<>}", { f(function(_, snip) return snip.captures[1] end), i(1), i(2), })),-- }}}
  -- TODO: Make the above snippets (sU, sS) only include \limits when used in display
  -- math mode, and not in inline math mode. (Not a big deal, will probably
  -- never be used anyways.)

  -- int -> \int_{}^{} {{{
  s({trig="([^%a])(i+)nt", name="\\int_{}^{}", dscr="integral (single or multiple)", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\<>nt_{<>}^{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        f(function(_, snip) return snip.captures[2] end),
        i(1),
        i(2),
      }
    )
  ),-- }}}
  -- oint -> \oint_{} {{{
  s({trig="([^%a])oint", name="\\oint_{}", dscr="closed path integral", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\oint_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
      }
    )
  ),-- }}}
  -- idint -> \idotsint_{} {{{
  s({trig="([^%a])idint", name="\\idotsint_{}", dscr="multiple integral with dots", regTrig=true, condition=in_mathzone, snippetType="autosnippet", wordTrig=false},
     fmta( "<>\\idotsint_{<>}",
      {
        f(function(_, snip) return snip.captures[1] end),
        i(1),
      }
    )
  ),-- }}}

  -- lim -> \lim_{} {{{
  snip_command('([^%a])lim', "\\lim_{<>}", { regTrig=true, name="\\lim_{...}", }),-- }}}
  -- sq -> \sqrt{} (wordTrig=false) {{{
  snip_command('([^%a])sq', "\\sqrt{<>}", {regTrig=true, name="\\sqrt{...}", }),-- }}}
  -- SQ -> \sqrt[]{} (wordTrig=false) {{{
  s({trig="SQ", name="\\sqrt[]{}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\sqrt[<>]{<>}", { i(1), d(2, get_visual), })),-- }}}

  -- exponentials, logarithms, trig functions {{{
  snip_command('([^%a\\])ee', "e^{<>}", { regTrig=true, name="e^{...}", }),
  snip_command('([^%a\\])EE', "\\exp\\left(<>\\right)", { regTrig=true, name="\\exp(...)", }),
  autoexpand('([^%a\\])log', "\\log", { regTrig=true, name="\\log", }),
  autoexpand('([^%a\\])lg', "\\lg", { regTrig=true, name="\\lg", }),
  autoexpand('([^%a\\])ln', "\\ln", { regTrig=true, name="\\ln", }),
  snip_command("([^%a\\])sin", "\\sin\\left(<>\\right)", { regTrig=true, name="\\sin(...)", }),
  snip_command("([^%a\\])Sin", "\\sin^2\\left(<>\\right)", { regTrig=true, name="\\sin^2(...)", }),
  snip_command("([^%a\\])cos", "\\cos\\left(<>\\right)", { regTrig=true, name="\\cos(...)", }),
  snip_command("([^%a\\])Cos", "\\cos^2\\left(<>\\right)", { regTrig=true, name="\\cos^2(...)", }),
  snip_command("([^%a\\])tan", "\\tan\\left(<>\\right)", { regTrig=true, name="\\tan(...)", }),
  snip_command("([^%a\\])Tan", "\\tan^2\\left(<>\\right)", { regTrig=true, name="\\tan^2(...)", }),
  -- }}}

  -- j< -> \inner{...}{} (NB! Custom command) {{{
  s({trig="j<", name="\\inner{...}{}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\inner{<>}{<>}", { d(1, get_visual), i(2), })),
  -- j> -> \inner{...}{} (NB! Custom command)
  s({trig="j>", name="\\inner{}{...}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\inner{<>}{<>}", { i(1), d(2, get_visual), })), -- }}}
  -- jn -> \norm{...} (NB! Custom command) {{{
  snip_command("jn", "\\norm{<>}", { name="\\norm{...}", dscr="norm" }),--}}}
  -- jm -> \min_{} {{{
  snip_command("jm", "\\min_{<>}", { name="\\min_{...}", dscr="minimum", }),-- }}}
  -- jM -> \max_{} {{{
  snip_command("jM", "\\max_{<>}", { name="\\max_{...}", dscr="maximum", }),-- }}}

  -- inf -> \inf_{} {{{
  snip_command("([^%a\\])inf", "\\inf_{<>}", { name="\\inf_{...}", dscr="infimum", regTrig=true }),-- }}}
  -- sup -> \sup_{} {{{
  snip_command("([^%a\\])sup", "\\sup_{<>}", { name="\\sup_{...}", dscr="supremum", regTrig=true, }),-- }}}
  -- arg -> \arg {{{
  autoexpand("([^%a\\])arg", "\\arg", { dscr="argument", regTrig=true, }),-- }}}
  -- ker -> \ker {{{
  autoexpand("([^%a\\])ker", "\\ker", { dscr="kernel", regTrig=true, }),-- }}}
  -- dim -> \dim {{{
  autoexpand("([^%a\\])dim", "\\dim", { dscr="dimension", regTrig=true, }),-- }}}

  -- TODO: Decide whether I like these snippets or not {{{
  -- spn -> \operatorname{span}
  autoexpand("([^%a\\])sp(a?)n", "\\operatorname{span}", { dscr="span", regTrig=true, }),
  -- ran -> \operatorname{ran} 
  autoexpand("([^%a\\])ran", "\\operatorname{ran}", { dscr="range", regTrig=true, }),
  -- rnk -> \operatorname{rank} 
  autoexpand("([^%a\\])rnk", "\\operatorname{rank}", { dscr="rank", regTrig=true, }),
  -- }}}

  -- }}}

  -- [[ cancel, overbrace, underbrace ]] {{{

  -- jx -> \cancel{...} {{{
  s({trig="jx", name="\\cancel{...}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
    fmta( "\\cancel{<>}", { d(1, get_visual), })),-- }}}
  -- joo -> \overbrace{...}{...} {{{
  s({trig="joo", name="\\overbrace{...}{...}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
    fmta( "\\overbrace{<>}^{<>}", { d(1, get_visual), i(2), })),-- }}}
  -- juu -> \underbrace{...}{...} {{{
  s({trig="juu", name="\\underbrace{...}{...}", snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
    fmta( "\\underbrace{<>}_{<>}", { d(1, get_visual), i(2), })),-- }}}

  -- }}}

  -- [[ Accents ]] (hat, tilde, bar, vec, overline/conj, ...) {{{
  -- h for "hat"
  -- hh -> \hat{...} {{{
  snip_command("hh", "\\hat{<>}", { name="\\hat{...}", dscr="Small hat accent", }),-- }}}
  -- hH -> \widehat{...} {{{
  snip_command("hH", "\\widehat{<>}", { name="\\widehat{...}", dscr="Long hat accent" }),-- }}}
  -- ht -> \tilde{...} {{{
  snip_command("(^g)ht", "\\tilde{<>}", { name="\\tilde{...}", dscr="Tilde accent", regTrig=true, }),-- }}}
  -- hT -> \widetilde{...} {{{
  snip_command("hT", "\\widetilde{<>}", { name="\\widetilde{...}", dscr="Long tilde accent" }),-- }}}
  -- hd -> \dot{...} (dhd -> \ddot, ddhd -> \dddot){{{
  s({trig="(d*)hd", name="\\dot{...}", dscr="Dot accent", regTrig=true, snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\<>dot{<>}", { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) })),-- }}}
  -- hb -> \bar{...} {{{
  snip_command("hb", "\\bar{<>}", { name="\\bar{...}", dscr="Small bar accent", }),-- }}}
  -- hO -> \overline{...} {{{
  snip_command("hO", "\\overline{<>}", { name="\\overline{...}", dscr="Long bar accent", }),-- }}}
  -- hv -> \vec {{{
  snip_command("hv", "\\vec{<>}", { name="\\vec{...}", dscr="Small vector arrow accent", }),-- }}}
  -- hV -> \overrightarrow{...} {{{
  snip_command("hV", "\\overrightarrow{<>}", { name="\\overrightarrow{...}", dscr="Long vector arrow accent", }),-- }}}

  -- jC -> \conj{...} (custom alias for \overline{...}) {{{
  snip_command("jC", "\\conj{<>}", { name="\\conj{...}", dscr="complex conjugate / overline" }),-- }}}

  -- }}}

  -- [[ Subscripts and superscripts ]] {{{

  -- __ -> _{...} {{{
  snip_command("__", "_{<>}", { name="_{...}", dscr="subscript", }),-- }}}
  -- ^^ -> ^{...} {{{
  snip_command("^^", "^{<>}", { name="^{...}", dscr="superscript", }),-- }}}
  -- SF -> superscript with parentheses {{{
  snip_command("SF", "^{(<>)}", { name="^{(...)}", dscr="superscript with parentheses", }),-- }}}
  -- sd -> subscript with upright text {{{
  snip_command("sd", "_{\\mathrm{<>}}", { name="_{\\mathrm{...}}", dscr="subscript with upright text", }),-- }}}
  -- SD -> superscript with upright text {{{
  snip_command("SD", "^{\\mathrm{<>}}", { name="^{\\mathrm{...}}", dscr="superscript with upright text", }),-- }}}

  -- ^I -> ^{-1} (inverse) {{{
  autoexpand("Î", "^{-1}", { dscr="inverse" }),-- }}}
  -- jT -> \tran (transpose) (NB! Custom command) {{{
  autoexpand("jT", "\\tran", { dscr="transpose" }),-- }}}
  -- jH -> \hermconj (hermitian conjugate) (NB! Custom command) {{{
  autoexpand("jH", "\\hermconj", { dscr="hermitian conjugate" }),-- }}}
  -- ^o -> \degree {{{
  autoexpand("ô", "\\degree", { dscr="degree symbol" }),-- }}}
  -- ^dg -> ^\dag {{{
  autoexpand("^dg", "^\\dag", { dscr="dagger superscript" }),-- }}}

  -- 00 -> _{0} {{{
  -- (only after letters and closing delimiters, but not in numbers like 100)
  s({trig='([%a%)%]%}])00', name="_{0}", dscr="subscript zero", regTrig=true, wordTrig=false, snippetType="autosnippet"},
    fmta( "<>_{<>}", { f(function(_, snip) return snip.captures[1] end), t("0") } ) ),-- }}}

  -- }}}

  -- [[ Nested math environments ]] jb[cbs...] (cases, bmatrix, split, ...) {{{
  -- j"begin"<letter>

  -- jbe -> \begin{...}...\end{...} (generic environment)
  s({trig="jbe", name="\\begin{...}...\\end{...}", dscr="(math) New generic environment", snippetType="autosnippet", wordTrig=false, condition=in_mathzone},
    fmta([[\begin{<>}<>\end{<>}]], { i(1), d(2, get_visual), rep(1), }) ),

  snip_begin_env("jbc", "cases"),
  snip_begin_env("jbs", "split", { multiline = true }),
  snip_begin_env("jbg", "gathered", { multiline = true }),
  snip_begin_env("jba", "aligned", { multiline = true }),
  snip_begin_env("jbm", "matrix"),
  snip_begin_env("jbp", "pmatrix"),
  snip_begin_env("jbb", "bmatrix"),
  snip_begin_env("jbB", "Bmatrix"),
  snip_begin_env("jbv", "vmatrix"),
  snip_begin_env("jbV", "Vmatrix"),

  -- m2x3 -> matrix contents with 2 rows and 3 cols (captial M for multiline)
  -- m2x3 -> 11 & 12\\ 21 & 22\\ 31 & 32 {{{
  s(
    { trig="([Mm])([%d]+)x([%d]+) ", name="m(rows)x(cols)", dscr="write matrix entries with specified dimensions", regTrig=true, snippetType="autosnippet"},
    d(1, function(_, snip)
      -- Get info from the trigger that was typed
      local multiline = snip.captures[1] == "M" and true or false
      local rows = tonumber(snip.captures[2]) or 2
      local cols = tonumber(snip.captures[3]) or 1

      local nodes = {} -- Will populate this with text nodes and insert nodes

      -- Generate default text for insert node at the given position.
      -- Returns "12" when row=1 and col=2 , or "1,2" if rows>=10 or cols>=10,
      -- or just "1" if cols=1.
      local function default_text(row, col)-- {{{
        local left = rows > 1 and tostring(row) or ""
        local right = cols > 1 and tostring(col) or ""
        local sep = ""
        -- Add a comma between row & col indices if they have more than 1 digit
        if left ~= "" and right ~= "" and (rows >= 10 or cols >= 10) then
          sep = ","
        end
        return left..sep..right
      end-- }}}

      for idx = 1, rows*cols do
        local row = math.floor((idx - 1) / cols) + 1
        local col = ((idx - 1) % cols) + 1

        if row ~= 1 and col == 1 and multiline then
          -- insert newline
          table.insert(nodes, t({"", ""}))
        end
        -- insert editable matrix entry
        table.insert(nodes, i(idx, default_text(row, col)))

        -- insert delimiter between entries
        if col == cols and row < rows then
          table.insert(nodes, t("\\\\ "))
        elseif col < cols then
          table.insert(nodes, t(" & "))
        end
      end

      -- wrap in a snippet_node so it's treated as a mini-snippet
      return sn(nil, nodes)
    end)
  ),-- }}}

  -- 2x space after \begin{...} adds a new correctly indented line below {{{
  s({ trig="(\\begin{.-})  ", name="2x space after \\begin{...}", dscr="<CR> and indent", regTrig=true, wordTrig=false, snippetType="autosnippet", },
    fmta(
      [[
        <>
            <>

      ]],
      {
        f( function(_, snip) return snip.captures[1] end ),
        i(1),
        -- f( function(_, snip) return snip.captures[2] end ),
      }
    )
  ),-- }}}

  -- }}}

  -- [[ Various symbols ]] (cdot, partial, subset, quad, nabla, infty, ...) {{{

  -- semantic shortcuts
  autoexpand("([^%a\\m])to", "\\to", { regTrig=true, dscr="same as \\rightarrow" }),
  autoexpand("([^%a])(\\?)mto", "\\mapsto", { regTrig=true, dscr="right arrow with a cap on the left end" }),
  autoexpand("([^%a\\])cd", "\\cdot", { regTrig=true, dscr="centered dot (multiplication)", }),
  autoexpand("([^%a\\])ci", "\\circ", { regTrig=true, dscr="circle (combination)", }),
  autoexpand("([^%a\\])not", "\\not", { regTrig=true, dscr="print a slash over the following symbol", }),
  autoexpand("([^%a])cnot", "\\centernot", --{{{ -- (NB! requires centernot package)
    { regTrig=true, dscr="like \\not, but centred horisontally", }),-- }}}
  -- (vd)ds -> \(vd)dots {{{
  s({trig="([vd]?)ds", name="\\dots", dscr="Ellipsis (normal, vertical or diagonal)", regTrig=true, snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\<>dots", { f(function(_, snip) return snip.captures[1] end), })),-- }}}
  autoexpand("df", "\\diff"), -- (NB! \diff is a custom command)
  autoexpand("dl", "\\partial"),
  autoexpand("sT", "\\text{ s.t. }", { dscr=[["such that" abbreviation]], }),
  autoexpand("::", "\\colon", { dscr="colon with less space before it", }),

  -- [ Subset & superset ] sbs/sps -> subset/superset {{{
  -- (n)sbs -> (\not)\subset {{{
  autoexpand("([^n])sbs", "\\subset", { dscr="strict subset", regTrig=true, }),
  autoexpand("nsbs", "\\not\\subset", { dscr="not strict subset" }),-- }}}
  -- (n)sbe -> \(n)subseteq {{{
  s({trig="(n?)sbe", name="\\(n)subseteq", dscr="(not) subset", regTrig=true, snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\<>subseteq", { f(function(_, snip) return snip.captures[1] end), })),-- }}}
  -- (n)sps -> (\not)\(n)supset {{{
  autoexpand("([^n])sps", "\\supset", { dscr="strict superset", regTrig=true, }),
  autoexpand("nsps", "\\not\\supset", { dscr="not strict superset" }),-- }}}
  -- (n)spe -> \(n)supseteq {{{
  s({trig="(n?)spe", name="\\(n)supseteq", dscr="(not) superset", regTrig=true, snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\<>supseteq", { f(function(_, snip) return snip.captures[1] end), })),-- }}}
  -- }}}

  -- [ Union & intersection ] jU/jS -> cup/cap {{{
  autoexpand("([^%a])jU", "\\cup", { regTrig=true, dscr="union", }),
  autoexpand("([^%a])jS", "\\cap", { regTrig=true, dscr="intersection", }),
  autoexpand("([^%a])JU", "\\bigcup", { regTrig=true, dscr="big union symbol", }),
  autoexpand("([^%a])JS", "\\bigcap", { regTrig=true, dscr="big intersection symbol", }),
  -- }}}

  -- j + letter
  -- (o)jt -> \(o)times {{{
  s({trig="(o?)jt", name="\\(o)times", dscr="cross product (tensor product)", regTrig=true, snippetType="autosnippet", condition=in_mathzone, wordTrig=false},
     fmta( "\\<>times", { f(function(_, snip) return snip.captures[1] end), })),-- }}}
  autoexpand("([^%a])je", "\\in", { regTrig=true, dscr="set membership", }), -- e for "element in"
  autoexpand("jq", "\\quad", { dscr="quad space", }),
  autoexpand("jQ", "\\qquad", { dscr="double quad space", }),
  autoexpand("ji", "\\infty", { dscr="infinity", }),
  autoexpand("j=", "\\approx", { dscr="approximately equal to", }),

  -- ,.
  autoexpand(",.<", "\\langle"), -- needed?
  autoexpand(",.>", "\\rangle"), -- needed?
  autoexpand(",.ø", "\\emptyset"), -- change trigger to jØ?
  autoexpand(",.A", "\\forall"),
  autoexpand(",.E", "\\exists"),
  autoexpand(",.N", "\\nabla"),

  -- }}}

  -- [[ Wrap in delimeters ]] js[lpbBvVacfe] {{{
  -- j"surround"<letter>

  -- jsl -> \left...\right {{{
  snip_command("jsl", [[\left<>\right]], { name="\\left...\\right", dscr="Surround with left/right delimeters", }),-- }}}
  -- jsp -> \left(...\right) {{{
  snip_command("jsp", [[\left(<>\right)]], { name="\\left(...\\right)", dscr="Surround with parenthesis delimeters", }),-- }}}
  -- jsb -> \left[...\right] {{{
  snip_command("jsb", "\\left[<>\\right]", { name="\\left[...\\right]", dscr="Surround with square bracket delimeters", }),-- }}}
  -- jsB -> \left\{...\right\} {{{
  snip_command("jsB", [[\left\{<>\right\}]], { name="\\left\\{...\\right\\}", dscr="Surround with curly brace delimeters", }),-- }}}
  -- jsv -> \left\lvert...\right\rvert {{{
  snip_command("jsv", [[\left\lvert<>\right\rvert]], { name="\\left\\lvert...\\right\\rvert", dscr="Surround with vertical bar delimeters", }),-- }}}
  -- jsV -> \left\lVert...\right\rVert {{{
  snip_command("jsV", [[\left\lVert<>\right\rVert]], { name="\\left\\lVert...\\right\\rVert", dscr="Surround with double vertical bar delimeters", }),-- }}}
  -- jsa -> \left\langle...\right\rangle {{{
  snip_command("jsa", [[\left\langle<>\right\rangle]], { name="\\left\\langle...\\right\\rangle", dscr="Surround with angle bracket delimeters", }),-- }}}
  -- jsc -> \left\lceil...\right\rceil {{{
  snip_command("jsc", [[\left\lceil<>\right\rceil]], { name="\\left\\lceil...\\right\\rceil", dscr="Surround with ceiling delimeters", }),-- }}}
  -- jsf -> \left\lfloor...\right\rfloor {{{
  snip_command("jsf", [[\left\lfloor<>\right\rfloor]], { name="\\left\\lfloor...\\right\\rfloor", dscr="Surround with floor delimeters", }),-- }}}
  -- jse -> \left. ... right\rvert_{} (evaluated at) {{{
  s({ trig="jsa", name="\\left. ...\\right\\rvert_{...}", dscr="'Evaluated at' vertical bar", wordTrig=false, snippetType="autosnippet" },
    fmta( [[\left.<>\rvert_{<>}]], { d(1, get_visual), i(2), } )),-- }}}

  -- }}}

  -- [[ Text styles ]] (text, substack, mathcal, mathrm, ...) {{{

  -- te -> \text{} {{{
  snip_command("([^%a])te", "\\text{<>}", { regTrig=true, name="\\text{...}", dscr="text in math zone" }),-- }}}
  -- tin -> \intertext{} {{{
  snip_command("([^%a])tin", "\\intertext{<>}", { regTrig=true, name="\\intertext{...}", dscr="text paragraph within multiline math environment, preserves alignment" }),-- }}}
  -- stk -> \substack{} {{{
  s({trig="([^%a])stk", name="\\substack{...}", regTrig=true, wordTrig=false, snippetType="autosnippet", condition=in_mathzone},
     fmta( [[\substack{<>\\ <>}]], { d(1, get_visual), i(2), })),-- }}}

  -- mc -> \mathcal{} (calligraphic) {{{
  snip_command("([^%a])mc", "\\mathcal{<>}", { regTrig=true, name="\\mathcal{...}", dscr="math calligraphic style", }),-- }}}
  -- mrm -> \mathrm{} (roman) {{{
  snip_command("([^%a])mrm", "\\mathrm{<>}", { regTrig=true, name="\\mathrm{...}", dscr="math roman style", }),-- }}}
  -- mbb -> \mathbb{} (blackboard bold) {{{
  snip_command("([^%a])mbb", "\\mathbb{<>}", { regTrig=true, name="\\mathbb{...}", dscr="math blackboard bold", }),-- }}}
  -- mbf -> \mathbf{} (boldface) {{{
  snip_command("([^%a])mbf", "\\mathbf{<>}", { regTrig=true, name="\\mathbf{...}", dscr="math boldface", }),-- }}}
  -- mit -> \mathit{} (italic) {{{
  snip_command("([^%a])mit", "\\mathit{<>}", { regTrig=true, name="\\mathit{...}", dscr="math italic", }),-- }}}
  -- msf -> \mathsf{} (sans serif) {{{
  snip_command("([^%a])msf", "\\mathsf{<>}", { regTrig=true, name="\\mathsf{...}", dscr="math sans serif", }),-- }}}
  -- mfk -> \mathfrak{} (fraktur) {{{
  snip_command("([^%a])mfk", "\\mathfrak{<>}", { regTrig=true, name="\\mathfrak{...}", dscr="math fraktur/gothic style", }),-- }}}

  -- mds -> \displaystyle {{{
  autoexpand("([^%a])mds", "\\textstyle", { regTrig=true, name="\\displaystyle", }),-- }}}
  -- mts -> \textstyle {{{
  autoexpand("([^%a])mts", "\\textstyle", { regTrig=true, name="\\textstyle", }),-- }}}
  -- msc -> \scriptstyle {{{
  autoexpand("([^%a])msc", "\\scriptstyle", { regTrig=true, name="\\scriptstyle", }),-- }}}
  -- mss -> \scriptscriptstyle {{{
  autoexpand("([^%a])mss", "\\scriptscriptstyle", { regTrig=true, name="\\scriptscriptstyle", }),-- }}}

  -- jop -> \operatorname{} (operator name) {{{
  snip_command("([^%a])jop", "\\operatorname{<>}", { regTrig=true, name="\\operatorname{...}", dscr="operator name", }),-- }}}

  -- }}}

  -- [[ Arrows ]] {{{
  -- Arrows             af[hjkløå] {{{
  autoexpand("afh", "\\leftarrow"),
  autoexpand("afj", "\\downarrow"),
  autoexpand("afk", "\\uparrow"),
  autoexpand("afl", "\\rightarrow"),
  autoexpand("afø", "\\leftrightarrow"),
  autoexpand("afå", "\\updownarrow"),-- }}}
  -- NOT arrows         afn[hlø] {{{
  autoexpand("afnh", "\\nleftarrow"),
  autoexpand("afnl", "\\nrightarrow"),
  autoexpand("afnø", "\\nleftrightarrow"),-- }}}
  -- Long arrows        af[HJKLØ] {{{
  autoexpand("afH", "\\longleftarrow"),
  autoexpand("afJ", "\\longdownarrow"),
  autoexpand("afK", "\\longuparrow"),
  autoexpand("afL", "\\longrightarrow"),
  autoexpand("afØ", "\\longleftrightarrow"),-- }}}
  -- Double arrows      aa[hjkløå] {{{
  autoexpand("aah", "\\Leftarrow", { dscr="Double left arrow" }),
  autoexpand("aaj", "\\Downarrow", { dscr="Double down arrow" }),
  autoexpand("aak", "\\Uparrow", { dscr="Double up arrow" }),
  autoexpand("aal", "\\Rightarrow", { dscr="Double right arrow" }),
  autoexpand("aaø", "\\Leftrightarrow", { dscr="Double left–right arrow" }),
  autoexpand("aaå", "\\Updownarrow", { dscr="Double up–down arrow" }),-- }}}
  -- Long double arrows ll[hjklø] {{{
  autoexpand("llh", "\\Longleftarrow", { dscr="Long double left arrow" }),
  autoexpand("llj", "\\Longdownarrow", { dscr="Long double down arrow" }),
  autoexpand("llk", "\\Longuparrow", { dscr="Long double up arrow" }),
  autoexpand("lll", "\\Longrightarrow", { dscr="Long double right arrow" }),
  autoexpand("llø", "\\Longleftrightarrow", { dscr="Long double left–right arrow" }),-- }}}
  -- NOT double arrows  aan[hlø] {{{
  autoexpand("aanh", "\\nLeftarrow", { dscr="NOT double left arrow" }),
  autoexpand("aanl", "\\nRightarrow", { dscr="NOT double right arrow" }),
  autoexpand("aanø", "\\nLeftrightarrow", { dscr="NOT double left–right arrow" }),-- }}}
  -- }}}

  -- [[ Greek letter snippets ]] ,.[abg...] {{{
  -- 'v' in front of letter for '\var___' variant
  -- q for theta, y for psi
  autoexpand(",.a", "\\alpha"),
  autoexpand(",.b", "\\beta"),
  autoexpand(",.g", "\\gamma"),
  autoexpand(",.G", "\\Gamma"),
  autoexpand(",.d", "\\delta"),
  autoexpand(",.D", "\\Delta"),
  autoexpand(",.ve", "\\varepsilon"),
  autoexpand(",.e", "\\epsilon"),
  autoexpand(",.z", "\\zeta"),
  autoexpand(",.h", "\\eta"),
  autoexpand(",.q", "\\theta"),
  autoexpand(",.vq", "\\vartheta"),
  autoexpand(",.Q", "\\Theta"),
  autoexpand(",.i", "\\iota"),
  autoexpand(",.k", "\\kappa"),
  autoexpand(",.vk", "\\varkappa"),
  autoexpand(",.l", "\\lambda"),
  autoexpand(",.L", "\\Lambda"),
  autoexpand(",.m", "\\mu"),
  autoexpand(",.n", "\\nu"),
  autoexpand(",.x", "\\xi"),
  autoexpand(",.p", "\\pi"),
  autoexpand(",.P", "\\Pi"),
  autoexpand(",.vp", "\\varpi"),
  autoexpand(",.r", "\\rho"),
  autoexpand(",.vr", "\\varrho"),
  autoexpand(",.s", "\\sigma"),
  autoexpand(",.vs", "\\varsigma"),
  autoexpand(",.S", "\\Sigma"),
  autoexpand(",.t", "\\tau"),
  autoexpand(",.u", "\\upsilon"),
  autoexpand(",.U", "\\Upsilon"),
  autoexpand(",.f", "\\phi"),
  autoexpand(",.vf", "\\varphi"),
  autoexpand(",.F", "\\Phi"),
  autoexpand(",.c", "\\chi"),
  autoexpand(",.y", "\\psi"),
  autoexpand(",.Y", "\\Psi"),
  autoexpand(",.w", "\\omega"),
  autoexpand(",.W", "\\Omega"),
-- }}}

}


-- vim: foldmethod=marker sw=2 sts=2 et nowrap
