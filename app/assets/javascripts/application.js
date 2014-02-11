//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.remotipart
//= require fancybox
//= require foundation

$(function(){ $(document).foundation(); });

$(function() {
  $(".fancybox").fancybox({
    padding: 0,
    helpers: {
      overlay: {
        locked: false
      }
    }
  });
});

$('input.datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

$("#modal").dialog({
  autoOpen: false,
  width: 750,
  modal: true,
  show: "fade",
  hide: "fade"
});
