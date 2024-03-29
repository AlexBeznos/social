jQuery ($) ->
  $(document).ready ->
    if $('.duplicatable_nested_form').length

      nestedForm = $('.duplicatable_nested_form').last().clone()
      formsOnPage    = $('.duplicatable_nested_form').length - 1

      $(".destroy_duplicate_nested_form:first").remove()
      $(".duplicatable_nested_form").append('<br />');

      $('body').on 'click','.destroy_duplicate_nested_form', (e) ->
        e.preventDefault()
        $(this).closest('.duplicatable_nested_form').slideUp().remove()

      $('.duplicate_nested_form').click (e) ->
        e.preventDefault()

        lastNestedForm = $('.duplicatable_nested_form').last()
        newNestedForm  = $(nestedForm).clone()
        formsOnPage += 1

        $(newNestedForm).find('label').each ->
          oldLabel = $(this).attr 'for'
          newLabel = oldLabel.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'for', newLabel

        $(newNestedForm).find('select, input').each ->
          oldId = $(this).attr 'id'
          newId = oldId.replace(new RegExp(/_[0-9]+_/), "_#{formsOnPage}_")
          $(this).attr 'id', newId
          $(this).attr 'disabled', false

          oldName = $(this).attr 'name'
          newName = oldName.replace(new RegExp(/\[[0-9]+\]/), "[#{formsOnPage}]")
          $(this).attr 'name', newName

        $( newNestedForm ).insertAfter( lastNestedForm )
