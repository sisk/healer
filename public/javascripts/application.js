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
  $('#risk_list').sortable({
    items:'.risk',
    containment:'parent',
    axis:'y',
    update: function() {
      $.post('/risks/sort', '_method=put&authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'));
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
  $("form#patient_edit").tabs();
  $(".choice_toggle").choice_toggle();
  $(".supplemental").supplementable();

  $(".risk_factor .record_delete").live('click', function(event){
    $(this).parents(".risk_factor").remove();
  });
  
});

jQuery(function ($) {
  $("a.record_delete[data-method='delete'][data-remote='true']").live('click', function (e){
    var the_deletable = $(this).closest(".deletable");
    the_deletable.fadeOut('medium',function(){the_deletable.remove()});
  });
});


// custom function for choice-toggling forms
(function($){
  $.fn.choice_toggle = function() {
    $(this).find(".choice .toggle").bind('click', function(event) {
      $(this).parent(".choice").siblings().find(".data").hide();
      $(this).parent(".choice").find(".data").fadeIn();
    });
    return this;
  }
}(jQuery));

// custom function for supplemental info boxes
(function($){
  $.fn.supplementable = function() {
    var toggle_trigger = $(this).find(".toggle");
    toggle_trigger.bind('click', function(event) {
      $(this).parent(".supplemental").find(".details").slideToggle("fast");
    });
    return this;
  }
}(jQuery));