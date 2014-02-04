jQuery(function ($) {
  if ($('.pagination').length) {
    $(window).scroll(function(){
      url = $('.pagination .next_page').attr('href');
      if (url && $(window).scrollTop() > ($(document).height() - $(window).height() - 250) ) {
        $('.pagination').html("<p class='fetching'><img class='ajax_loader' src='/assets/ajax-loader.gif' /><span>Fetching more patients. Please wait...</span></p>");
        $.getScript(url);
      }
    });
    $(window).scroll();
  }
});