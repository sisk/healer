//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.remotipart
//= require fancybox
//= require foundation

$(function(){ $(document).foundation(); });
$(function() { $(".fancybox").fancybox(); });
$("#modal").dialog({
  autoOpen: false,
  width: 750,
  modal: true,
  show: "fade",
  hide: "fade"
});
