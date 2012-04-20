$(function() {
  $('[data-remote][data-replace]')
    .data('type', 'html')
    .on('ajax:success', function(event, data) {
      var $this = $(this);
      $($this.data('replace')).html(data);

      // If you need to do something after replacing, you can listen to the ajax:replaced event on the link.
      $this.trigger('ajax:replaced');
    });
});

// Rails:
// link_to 'Do something', path_returning_partial, :remote => true, :"data-replace" => '#some_id'

// Source: https://makandracards.com/makandra/1383-rails-3-make-link_to-remote-true-replace-html-elements-with-jquery
