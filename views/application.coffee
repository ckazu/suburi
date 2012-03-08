# -*- coding: utf-8 -*-
# need to refactor!
$ ->
  initializeAll()

initializeAll = =>
  @level = 5
  $('header nav').on 'click', 'li', (e) => initialize(e)

initialize = (e) =>
  clearData()

  words = selectWordList(e.target.className)

  $('#field').text tracingWords(words)
  $('#field ul:first').addClass('current')
  $('#field ul > li:first').addClass('current')
  $('#field ul > li > span:first').addClass('current')
  $('#field').fadeIn()
  $('body').on 'keypress', (e) -> type(e)

clearData = =>
  $('#field').hide()
  $('#tweet-result').hide()
  @counter = 0
  @correct = 0
  $('#field').empty()
  $('#result').empty()
  $('#tweet-result').empty()
  $('body').off 'keypress'

type = (e) =>
  return if $('#field ul.current').length is 0

  if e.ctrlKey
    switch e.which
      when 74, 77, 78           # c-j, c-m, c-n
        nextWord()
      else
        return
  else
    switch e.which
      when 13, 32               # enter, space
        nextWord()
        e.preventDefault()      # prevent scroll of browser
      else
        input(String.fromCharCode(e.which))

  $('#result').text "#{@counter}, #{@correct}"

tracingWords = (_words) =>
  words = []
  _words = _.shuffle(_words)

  if _words.length > 10
    _(10).times => words.push _words.pop()
  else
    words = _words

  _.each words, (word) ->
    ul = $('<ul/>')
    _(@level).times ->
      ul.append $('<li/>').html(generateWord(word))
    ul.appendTo($('#field'))

  # need refactoring
  ul = $('<ul/>')
  _(@level * Math.floor(words.length / 2)).times ->
    ul.append $('<li/>').html(generateWord(sample(words)))
  ul.appendTo($('#field'))

generateWord = (word) =>
  ret = ''
  _(word.length).times (n) ->
    ret += "<span>#{word.charAt(n)}</span>"
  ret

checkAnswer = =>
  if $('#field ul.current li.current span').length == $('#field ul.current li.current span.correct').length
    $('#field ul.current li.current').addClass('correct')
    @correct++
  else
    $('#field ul.current li.current').addClass('wrong')

nextWord = =>
  checkAnswer()
  if $('#field ul.current li.current').next().length isnt 0
    $('#field ul.current li.current').removeClass('current')
                                     .find('span').removeClass('current')
                                     .parent().next().addClass('current')
                                     .find('span:first').addClass('current')
  else if $('#field ul.current').next().length isnt 0
    $('#field ul.current li.current').removeClass('current')
                                     .find('span').removeClass('current')
                                     .closest('ul').removeClass('current')
                                     .next().addClass('current')
                                     .find('li:first').addClass('current')
                                     .find('span:first').addClass('current')
    $('body').animate {scrollTop: $('#field ul.current').position().top - 120}, 99, 'swing'
  else
    $('#field ul.current li.current').removeClass('current')
                                     .find('span').removeClass('current')
                                     .closest('ul').removeClass('current')
    $('#tweet-result').fadeIn('fast')
    $('#footer').fadeIn('fast')
    $('#tweet-result').html tweetButton()

  undefined

input = (code) =>
  el = $('#field ul.current > li.current > .current')

  if el.hasClass 'wrong'
    judge = 'wrong'
  else
    judge = if(el.text().charAt(0) == code) then 'correct' else 'wrong'
    @counter++

  if el.next().length isnt 0
    el.append(code)
      .removeClass('current')
      .addClass(judge)
      .next()
      .addClass('current')
  else
    el.append(code)
      .addClass(judge)

sample = (array) =>
  array[Math.floor(Math.random() * array.length)]

tweetButton = =>
  text = "#{@counter} charactors Suburi! done."
  "<a href='https://twitter.com/share' class='twitter-share-button' data-url='http://suburi.herokuapp.com/' data-text='#{text}' data-lang='ja' data-size='large' data-count='true' data-hashtags='suburi'>tweet</a><script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src='//platform.twitter.com/widgets.js';fjs.parentNode.insertBefore(js,fjs);}}(document,'script','twitter-wjs');</script>"

# move to json, db or localstorage
selectWordList = (type) =>
  switch type
    when 'git'
      ['git', 'reflog', 'status', 'diff', 'reset', 'push', 'branch', 'checkout', 'stash', 'blame', 'log', 'show', 'commit', 'whatchanged', 'add', 'rm', '--amend', '--continue', '--abort', 'merge', 'origin', 'master', 'cherry-pick', 'rebase', 'fetch', 'pull', 'revert', '--hard', '--soft', '--amend', 'HEAD', 'remote', 'submodule', 'format-patch', 'am', 'tag']
    when 'string'
      ["%", "*", "+", "<<", "<=>", "==", "===", "=~", "[]", "[]=", "ascii_only?", "bytes", "bytesize", "byteslice", "capitalize", "capitalize!", "casecmp", "center", "chars", "chomp", "chomp!", "chop", "chop!", "chr", "clear", "codepoints", "concat", "count", "crypt", "delete", "delete!", "downcase", "downcase!", "dump", "each_byte", "each_char", "each_codepoint", "each_line", "empty?", "encode", "encode!", "encoding", "end_with?", "eql?", "force_encoding", "getbyte", "gsub", "gsub!", "hash", "hex", "include?", "index", "initialize_copy", "insert", "inspect", "intern", "length", "lines", "ljust", "lstrip", "lstrip!", "match", "next", "next!", "oct", "ord", "partition", "prepend", "replace", "reverse", "reverse!", "rindex", "rjust", "rpartition", "rstrip", "rstrip!", "scan", "setbyte", "size", "slice", "slice!", "split", "squeeze", "squeeze!", "start_with?", "strip", "strip!", "sub", "sub!", "succ", "succ!", "sum", "swapcase", "swapcase!", "to_c", "to_f", "to_i", "to_r", "to_s", "to_str", "to_sym", "tr", "tr!", "tr_s", "tr_s!", "unpack", "upcase", "upcase!", "upto", "valid_encoding?"]
    when 'array'
      ["&", "*", "+", "-", "<<", "<=>", "==", "[]", "[]=", "assoc", "at", "clear", "collect", "collect!", "combination", "compact", "compact!", "concat", "count", "cycle", "delete", "delete_at", "delete_if", "drop", "drop_while", "each", "each_index", "empty?", "eql?", "fetch", "fill", "find_index", "first", "flatten", "flatten!", "frozen?", "hash", "include?", "index", "initialize_copy", "insert", "inspect", "join", "keep_if", "last", "length", "map", "map!", "pack", "permutation", "pop", "product", "push", "rassoc", "reject", "reject!", "repeated_combination", "repeated_permutation", "replace", "reverse", "reverse!", "reverse_each", "rindex", "rotate", "rotate!", "sample", "select", "select!", "shift", "shuffle", "shuffle!", "size", "slice", "slice!", "sort", "sort!", "sort_by!", "take", "take_while", "to_a", "to_ary", "to_s", "transpose", "uniq", "uniq!", "unshift", "values_at", "zip", "|"]
    when 'enumerable'
      ["all?", "any?", "chunk", "collect", "collect_concat", "count", "cycle", "detect", "drop", "drop_while", "each_cons", "each_entry", "each_slice", "each_with_index", "each_with_object", "entries", "find", "find_all", "find_index", "first", "flat_map", "grep", "group_by", "include?", "inject", "map", "max", "max_by", "member?", "min", "min_by", "minmax", "minmax_by", "none?", "one?", "partition", "reduce", "reject", "reverse_each", "select", "slice_before", "sort", "sort_by", "take", "take_while", "to_a", "zip"]
    when 'metasyntactic'
      ['hoge', 'fuga', 'piyo', 'foo', 'bar', 'baz']
    else
      ['aiueo', 'kakikukeko', 'sashisuseso', 'tachitsuteto', 'naninuneno', 'hahifuheho', 'mamimumemo', 'yayuyo', 'wawon']
