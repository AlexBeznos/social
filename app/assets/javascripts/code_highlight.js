/*
*= require jquery.minicolors
*= require codemirror
*= require codemirror/modes/css
*= require codemirror/modes/javascript
*/

$(document).ready(function() {
  if($('#style_css')[0]) {
    CodeMirror.fromTextArea($('#style_css')[0], {
      mode: "text/html",
      lineNumbers: true,
      tabSize: 4,
      scrollbarStyle: 'native',
      mode: "css"
    });
  }

  if($('#style_js')[0]) {
    CodeMirror.fromTextArea($('#style_js')[0], {
      mode: "text/html",
      lineNumbers: true,
      tabSize: 2,
      scrollbarStyle: 'native',
      mode: "javascript"
    });
  }

  $('[data-minicolors]').each(function(i, elem) {
    var input = $(this);
    input.minicolors({
      theme: 'bootstrap'
    });
  });

  $('.line_minicolors').minicolors({
      theme: 'bootstrap',
      opacity: true
  });
});
