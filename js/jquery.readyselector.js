// taken from
// https://gist.github.com/2596712

/*
   With the Rails asset pipeline, you usually include the JS for
   your entire application in one bundle, but individual scripts
   should be run only on certain pages. This extends jQuery's
   .ready() to provide a nice syntax for page-specific script:

     $('.posts.index').ready(function () {
       // ...
     });

   This works well if you include the controller name and action
   as <body> element classes, a la:
    http://postpostmodern.com/instructional/a-body-with-class/

   The callback will be run once for each matching element, with
   the usual 'this' context for a jQuery callback. `$(fn)`,
   `$(document).ready(fn)`, and `$().ready(fn)` behave as normal.
*/

(function ($) {
  var ready = $.fn.ready;
  $.fn.ready = function (fn) {
    if (this.context === undefined) {
      // The $().ready(fn) case.
      ready(fn);
    } else if (this.selector) {
      ready($.proxy(function(){
        $(this.selector, this.context).each(fn);
      }, this));
    } else {
      ready($.proxy(function(){
        $(this).each(fn);
      }, this));
    }
  }
})(jQuery);
