$('a[href^="#"][data-animate]').on('click', function() {
  var hash = $(this).attr('href');
  var offset = $(hash).offset();
  if (offset) {
      $('html, body').animate({ scrollTop: offset.top }, 'slow');
      location.hash = hash;
      return false;
    }
});

// Source: https://makandracards.com/makandra/1257-soft-scroll-to-an-anchor-with-jquery
