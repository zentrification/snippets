$(function() {
    function selectVisibility() {
      var selector = $($(this).attr('data-selects-visibility'));
      var value = $(this).val();
      if ($(this).is('input[type="checkbox"]')) {
        if ($(this).is(':checked')) {
          value = '_checked';
        } else {
          value = '_unchecked';
        }
      } else if ( value == '' ) {
        value = '_blank';
      }
      selector.filter('[data-show-for]:not([data-show-for~="' + value + '"])').hide();
      selector.filter('[data-hide-for~="' + value + '"]').hide();
      selector.filter('[data-hide-for]:not([data-hide-for~="' + value + '"])').show();
      selector.filter('[data-show-for~="' + value + '"]').show();
    }

    $(this).find('[data-selects-visibility]').change(selectVisibility);
    $(this).find('select[data-selects-visibility]').each(selectVisibility);
    $(this).find('input[data-selects-visibility][type="checkbox"]').each(selectVisibility);
    $(this).find('input[data-selects-visibility][type="radio"]:checked').each(selectVisibility);
});

// Rails:
// <%= form.check_box :check_box, :"data-selects-visibility" => ".triggered_by_checkbox" %>
// <%= form.select :advancedness, [['basic', 'basic'], ['advanced', 'advanced'], ['very advanced', 'very_advanced]], {}, :"data-selects-visibility" => ".sub_form" %>

// Source: https://makandracards.com/makandra/642-unobtrusive-jquery-to-toggle-visibility-with-selects-and-checkboxes
