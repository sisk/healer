jQuery.ajaxSetup({
  'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function() {
  // hack to fix the way Rails does authenticity_token output in form_for
  $("input[name=authenticity_token]").parent("div").hide();

  $('#disease_list').sortable({
    items:'.disease',
    containment:'parent',
    axis:'y',
    update: function() {
      $.ajax({
        url: '/diseases/sort',
        data: 'authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'),
        type: 'PUT'
      });
    }
  });
  $('#risk_list').sortable({
    items:'.risk',
    containment:'parent',
    axis:'y',
    update: function() {
      $.ajax({
        url: '/risks/sort',
        data: 'authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'),
        type: 'PUT'
      });
    }
  });
  $('#procedure_list').sortable({
    items:'.procedure',
    containment:'parent',
    axis:'y',
    update: function() {
      $.ajax({
        url: '/procedures/sort',
        data: 'authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'),
        type: 'PUT'
      });
    }
  });

  $('input.ui-datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

  $(".enlarge a").fancybox({
    'hideOnContentClick': true,
    'titlePosition': 'over'
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
      $(this).closest(".choice").siblings().find(".data").addClass("hide");
      $(this).closest(".choice").find(".data").removeClass("hide");
    });
    return this;
  }
}(jQuery));

// custom function for supplemental info boxes
(function($){
  $.fn.supplementable = function() {
    var toggle_trigger = $(this).find(".toggle");
    toggle_trigger.bind('click', function(event) {
      $(this).closest(".supplemental").find(".details").slideToggle("fast");
    });
    return this;
  }
}(jQuery));