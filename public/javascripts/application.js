jQuery.ajaxSetup({
  'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
});

$(document).ready(function() {
  // hack to fix the way Rails does authenticity_token output in form_for
  $("input[name=authenticity_token]").parent("div").hide();

  $('input.ui-datepicker').datepicker({ dateFormat: 'yy-mm-dd' });

  $(".zoom a").fancybox({
    'hideOnContentClick': true,
    'titlePosition': 'over'
  });

  $("#registrations").tabs();
  $("#show_schedule_list").tabs();
  $("form#patient_edit").tabs();
  $(".choice_toggle").choice_toggle();
  $(".supplemental").supplementable();

  $(".risk_factor .record_delete").live('click', function(event){
    $(this).parents(".risk_factor").remove();
  });

  $(".menu_select .toggle").click(function(event){
    $(this).siblings(".menu").slideToggle(100);
  });
  $(".menu_select").mouseleave(function(event){
    $(this).find(".menu").slideUp(100);
  });

  $("#ipad_hint").dialog({
    buttons: { "OK": function() { $(this).dialog("close"); } },
    dialogClass: 'instructions',
    modal: true,
    width: 500
  });
  $("#diagnosis_inline_edit").dialog({
    autoOpen: false,
    height: 600,
    width: 750,
    modal: true,
    show: "fade",
    hide: "fade"
  });

  $(".xray.preview").live('mouseover', function(event) {
    $(this).find(".nav").fadeIn();
  });
  $(".xray.preview").live('mouseleave', function(event) {
    $(this).find(".nav").fadeOut();
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

(function($){
  $.fn.toggle_empty_class = function() {
    if ($(this).children().length == 0) {
      $(this).addClass("empty");
    } else {
      $(this).removeClass("empty");
    }
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

// custom function for sortable lists
(function($){
  $.fn.orderable = function(sort_url) {
    $(this).sortable({
      items: ".orderable",
      containment: "parent",
      axis: "y",
      update: function() {
        $.ajax({
          url: sort_url,
          data: 'authenticity_token=meta[name=csrf-token]&'+$(this).sortable('serialize'),
          type: 'PUT'
        });
      }
    });
    return this;
  }
}(jQuery));
