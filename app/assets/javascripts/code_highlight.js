/*
*= require codemirror
*= require codemirror/modes/css
*= require codemirror/modes/javascript
*= require jquery.minicolors
*/

$(document).ready(function() {
  CodeMirror.fromTextArea($('#style_css')[0], {
    mode: "text/html",
    lineNumbers: true,
    tabSize: 4,
    scrollbarStyle: 'native',
    mode: "css"
  });

  CodeMirror.fromTextArea($('#style_js')[0], {
    mode: "text/html",
    lineNumbers: true,
    tabSize: 2,
    scrollbarStyle: 'native',
    mode: "javascript"
  });

  $('[data-minicolors]').each(function(i, elem) {
    var input = $(this);
    input.minicolors({
      theme: 'bootstrap'
    });
  });
});
