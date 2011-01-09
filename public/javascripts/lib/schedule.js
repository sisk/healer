$(document).ready(function() {

  $(".room.connectedSortable").sortable({
    items: ".sortable",
    placeholder: "registration_order_placeholder",
    connectWith: ".connectedSortable",
    opacity: 0.7,
    helper: "clone",
    cursor: "move",
    receive: function(event, ui) {
      // stop moved items from re-rendering in the source column
      ui.sender.find("#"+ui.item.attr("id")).remove();
      //alert("sender:" + ui.sender.attr("id"));
    },
    update: function(event, ui) {
      var enclosure, room_id, day_num, params, template, url, item_id;
      item_id = ui.item.attr("id");
      enclosure = $(this).closest(".room");
      
      room_id = $(this).closest(".room").attr("class").match(/room_(\d+)/)[1];
      day_num = $(this).closest(".room").attr("class").match(/day_(\d+)/)[1];
      
      params = enclosure.sortable("serialize") + "&room_id=" + room_id + "&day=" + day_num;
      template = Handlebars.compile($("script[name=registration_scheduled_template]").html());
      //url = "/trips/#{@trip.id}/schedule/sort_room.json";
      url = "/trips/1/schedule/sort_room.json";

      // alert("updating room: " + room_id + ", day: " + day_num);
      enclosure.html('<img class="ajax_loader" src="/images/ajax-loader.gif" />');

      $.getJSON(url, params, function(data) {
        enclosure.html(template(data));
        if (ui.sender) {
          // alert("there was a sender:" + ui.sender.attr("id"));
          // stop moved items from re-rendering in the source column
        }
      });
      $("#"+item_id).flash();
    }
  }).disableSelection();

  $("#unscheduled").sortable({
    items: ".sortable",
    placeholder: "registration_order_placeholder",
    connectWith: ".connectedSortable",
    opacity: 0.7,
    helper: "clone",
    cursor: "move",
    receive: function(event, ui) {
      // stop moved items from re-rendering in the source column
      ui.sender.find("#"+ui.item.attr("id")).remove();
      //alert("sender:" + ui.sender.attr("id"));
    },
    update: function(event, ui) {
      var enclosure, params, template, url, item_id;
      item_id = ui.item.attr("id");
      enclosure = $(this).closest(".registrations");
      params = enclosure.sortable("serialize");

      // alert("updating unscheduled");
      enclosure.html('<img class="ajax_loader" src="/images/ajax-loader.gif" />');

      template = Handlebars.compile($("script[name=registration_unscheduled_template]").html());
      //url = "/trips/#{@trip.id}/schedule/sort_unscheduled.json";
      url = "/trips/1/schedule/sort_unscheduled.json";
      $.getJSON(url, params, function(data) {
        enclosure.html(template(data));
        if (ui.sender) {
          // stop moved items from re-rendering in the source column
          ui.sender.find("#"+ui.item.attr("id")).remove();
        }
      });

      $("#"+item_id).flash();
    }
  }).disableSelection();

  /*
  $(".registration").find(".unschedule").live("click", function(event) {
    var registration, enclosure, loader;
    loader = '<img class="ajax_loader" src="/images/ajax-loader.gif" />';
    registration = $(this).closest(".registration");
    enclosure = $(this).closest(".room");
    $("#unscheduled").html(loader);
    enclosure.html(loader);
    
    unscheduled_template = Handlebars.compile($("script[name=registration_unscheduled_template]").html());
    scheduled_template = Handlebars.compile($("script[name=registration_scheduled_template]").html());
    

    alert("un:" + registration.attr("id"));
    event.preventDefault();
  });
  */
});