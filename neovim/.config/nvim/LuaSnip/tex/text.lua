local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- Summary: When `LS_SELECT_RAW` is populated with a visual selection, the function
-- returns an insert node whose initial text is set to the visual selection.
-- When `LS_SELECT_RAW` is empty, the function simply returns an empty insert node.
local get_visual = function(args, parent)
  if (#parent.snippet.env.LS_SELECT_RAW > 0) then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else  -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1))
  end
end

local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1 -- Requires the VimTeX plugin
end

local in_text = function() return not in_mathzone() end

local line_begin = require("luasnip.extras.expand_conditions").line_begin

local line_begin_in_text = function(line_to_cursor, matched_trigger)
  return in_text() and line_begin(line_to_cursor, matched_trigger)
end

-- Snippet generator: create section headers with h1, h2, h3
local function section_snippet(level, description) -- {{{
  local trigger = "h" .. level
  local text = "\\" .. string.rep("sub",level - 1) .. "section{<>}"
  local name = "\\" .. string.rep("sub",level - 1) .. "section{...}"
  return s({trig = trigger, name=name, dscr=description, condition=line_begin_in_text, snippetType="autosnippet"},
    fmta(
      text,
      { i(1) }
    )
)
end-- }}}

-- Snippet generator: autoexpand in text
-- default opts: { name=text, condition=in_text, wordTrig=false, regTrig=false }
local function autoexpand(trigger, text, opts) -- {{{
  if opts then
    opts.regTrig = opts.regTrig or false
    opts.wordTrig = opts.wordTrig or false
    opts.name = opts.name or text
    opts.dscr = opts.dscr or nil
    opts.condition = opts.condition or in_text
  else
    opts = { regTrig=false, wordTrig=false, name=text, condition=in_text }
  end
  if opts.regTrig then
    return s(
      {
        trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=opts.condition,
        wordTrig=false, regTrig=opts.regTrig
      },
      { f(function(_, snip) return snip.captures[1] end), t(text), }
    )
  end

  return s({trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=opts.condition,
    wordTrig=opts.wordTrig}, { t(text), })
end-- }}}

-- Snippet generator: for any text with exactly one node, indicated with <>.
-- Uses d(1, get_visual) as the snippet node, meaning it can wrap LS_SELECT_RAW.
-- default opts: { name=text, condition=in_text, wordTrig=false, regTrig=false }
-- NOTE: opts.regTrig only works for using a lua pattern to match a single
-- character at the beginning of the trigger
local function snip_command(trigger, text, opts)-- {{{
  if opts then
    opts.regTrig = opts.regTrig or false
    opts.wordTrig = opts.wordTrig or false
    opts.name = opts.name or string.gsub(text, "<>", "...")
    opts.dscr = opts.dscr or nil
    opts.condition = opts.condition or in_text
  else
    opts = { regTrig=false, wordTrig=false, name=string.gsub(text, "<>", "..."), condition=in_text }
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
      {trig=trigger, name=opts.name, dscr=opts.dscr, regTrig=true, wordTrig=false, condition=opts.condition, snippetType="autosnippet"},
      fmta(
        "<>"..text,
        { f(function(_, snip) return snip.captures[1] end), d(1, get_visual) }
      )
    )
  end
  return s(
    {trig=trigger, name=opts.name, dscr=opts.dscr, snippetType="autosnippet", condition=opts.condition, wordTrig=opts.wordTrig},
    fmta( text, { d(1, get_visual), })
  )
end-- }}}

-- Snippet generator: \begin{...}...\end{...}
local function snip_begin_env(trigger, env_name, opts)-- {{{
  opts.multiline = opts.multiline or false -- put \begin & \end on one line by default
  opts.cond = opts.cond or nil

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

  return s({
    trig = trigger,
    name = env_name,
    dscr="New "..env_name.." environment",
    snippetType="autosnippet",
    wordTrig=false,
    condition=opts.cond },
    fmta(text, { d(1, get_visual), }) )
end-- }}}

return {
  -- [[ Section snippets ]]
  -- h1, h2, h3 -> section, subsection, subsubsection {{{
  section_snippet(1, "Top-level section"),
  section_snippet(2, "Second-level subsection"),
  section_snippet(3, "Third-level subsection"),
  -- }}}

  -- mm -> $...$ (inline math) {{{
  s({ trig = "([^%a])mm", name="$...$", dscr="Inline math", wordTrig = false, regTrig = true, snippetType="autosnippet",
    condition=in_text },
    fmta("<>$<>$",
      {
        f( function(_, snip) return snip.captures[1] end ), -- reinsert the regex capture group
        d(1, get_visual),
      }
    )
  ),-- }}}

  -- [[ Labels and references ]] {{{

  snip_command("lbl", "\\label{<>}", { wordTrig=true, condition=function() return true end }),
  snip_command("jc", "\\cite{<>}", { dscr="citation" }),
  -- jC -> \cite[...]{...} {{{
  s({ trig="jC", name="\\cite[...]{...}", dscr="citation with page number", condition=in_text, wordTrig=false, snippetType="autosnippet" },
    fmta( "\\cite[<>]{<>}", { i(1), d(2, get_visual), } )),-- }}}
  snip_command("jr", "\\ref{<>}"),
  snip_command("je", "\\eqref{<>}", { wordTrig=true }),

  -- }}}

  -- [[ Create environments ]] {{{

  -- nb -> \begin{...}...\end{...} {{{
  s({trig="nb", name="begin-end", dscr="A generic new environment", condition=line_begin_in_text, snippetType="autosnippet"},
    fmta(
      [[
        \begin{<>}
            <>
        \end{<>}
      ]],
      { i(1), d(2, get_visual), rep(1), })), -- }}}

  -- nn -> \begin{equation}...\end{equation} ( nN for equation* ) {{{
  snip_begin_env("nn", "equation", {multiline=true, cond=line_begin_in_text}),
  snip_begin_env("nN", "equation*", {multiline=true, cond=line_begin_in_text}), -- }}}
  -- nl -> \begin{align}...\end{align} ( nL for align* ) {{{
  snip_begin_env("nl", "align", {multiline=true, cond=line_begin_in_text}),
  snip_begin_env("nL", "align*", {multiline=true, cond=line_begin_in_text}), -- }}}
  -- ng -> \begin{gather}...\end{gather} ( nG for gather* ) {{{
  snip_begin_env("ng", "gather", {multiline=true, cond=line_begin_in_text}),
  snip_begin_env("nG", "gather*", {multiline=true, cond=line_begin_in_text}), -- }}}
  -- nm -> \begin{multline}...\end{multline} ( nM for multline* ) {{{
  snip_begin_env("nm", "multline", {multiline=true, cond=line_begin_in_text}),
  snip_begin_env("nM", "multline*", {multiline=true, cond=line_begin_in_text}), -- }}}

  -- nf -> \begin{figure}... {{{
  s({ trig="nf", name="\\begin{figure}...", dscr="Insert a figure", condition=line_begin_in_text, snippetType="autosnippet" },
    fmta(
      [[
      \begin{figure}[<>]
          \centering
          \includegraphics[width=<>]{<>}
          \caption{<>}
          \label{fig:<>}
      \end{figure}
      ]],
      {
        i(1, "h"),
        i(2, "0.65\\linewidth"),
        i(3, "path/to/figure"),
        i(4),
        i(5),
      }
    )
  ),
  -- }}}

  -- ni -> \begin{itemize}...\end{itemize} {{{
  snip_begin_env("ni", "itemize", {multiline=true, cond=line_begin_in_text}), -- }}}
  -- ne -> \begin{enumerate}...\end{enumerate} {{{
  snip_begin_env("ne", "enumerate", {multiline=true, cond=line_begin_in_text}), -- }}}
  -- nd -> \begin{description}...\end{description} {{{
  snip_begin_env("nd", "description", {multiline=true, cond=line_begin_in_text}), -- }}}

  -- }}}

  -- [[ Backslash shortcuts ]]
  -- jl -> \ {{{
  s({trig="jl", name="\\", dscr="\\ (backslash)", snippetType="autosnippet", wordTrig=false},
    {t("\\")}),-- }}}
  -- JL -> \\ {{{
  s({trig="JL", name="\\\\", dscr="\\\\ (double backslash)", snippetType="autosnippet", wordTrig=false},
    {t("\\\\")}),-- }}}

-- [[ Font styles ]] (italic, bold, emph, typewriter, verbatim) {{{

  -- tii -> \textit{...} (italic) {{{
  s({trig = "tii", name="\\textit{...}", dscr = "Italic", snippetType="autosnippet"},
    fmta("\\textit{<>}", { d(1, get_visual), }) ),-- }}}
  -- tbb -> \textbf{...} (boldface) {{{
  s({trig = "tbf", name="\\textbf{...}", dscr = "Boldface", snippetType="autosnippet"},
    fmta("\\textbf{<>}", { d(1, get_visual), }) ),-- }}}
  -- tmm -> \emph{...} (emphasis) {{{
  s({trig = "tmm", name="\\emph{...}", dscr = "Emphasis", snippetType="autosnippet"},
    fmta("\\emph{<>}", { d(1, get_visual), }) ),-- }}}
  -- ttt -> \texttt{...} (typewriter text) {{{
  s({trig = "ttt", name="\\texttt{...}", dscr = "Typewriter text", snippetType="autosnippet"},
    fmta("\\texttt{<>}", { d(1, get_visual), }) ),-- }}}
  -- tsc -> \textsc{...} (small caps) {{{
  s({trig = "tsc", name="\\textsc{...}", dscr = "Small caps", snippetType="autosnippet"},
    fmta("\\textsc{<>}", { d(1, get_visual), }) ),-- }}}
  -- tvv -> \verb|...| (verbatim) {{{
  s({trig = "tvv", name="\\verb|...|", dscr = "Verbatim", snippetType="autosnippet"},
    fmta("\\verb|<>|", { d(1, get_visual), }) ),-- }}}

  -- }}}

}

-- vim: foldmethod=marker
