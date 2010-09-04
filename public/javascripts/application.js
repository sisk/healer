$(document).ready(function() {
  // hack to fix the way Rails does authenticity_token output in form_for
  $("input[name=authenticity_token]").parent("div").hide();

  $('#disease_list').sortable({
    items:'.disease',
    containment:'parent',
    axis:'y',
    update: function() {
      $.post('/diseases/sort', '_method=put&authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'));
    }
  });
  $('#procedure_list').sortable({
    items:'.procedure',
    containment:'parent',
    axis:'y',
    update: function() {
      $.post('/procedures/sort', '_method=put&authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'));
    }
  });

  $('input.ui-datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

  $(".enlarge a").fancybox({
    'hideOnContentClick': true,
    'titlePosition': 'inside'
  });

  $("#registration_list").tabs();
  $(".choice_toggle").choice_toggle();

});


// custom function for choice-toggling forms
(function($){
  $.fn.choice_toggle = function() {
    $(this).find(".choice .toggle").bind('click', function(event) {
      $(this).parent(".choice").siblings().find(".data").hide();
      $(this).parent(".choice").find(".data").fadeIn();
    });
    return this
  }
}(jQuery));