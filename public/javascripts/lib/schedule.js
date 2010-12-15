$(document).ready(function() {

  markBilateral();

  $(".room.connectedSortable").sortable({
    items: ".sortable",
    placeholder: "registration_order_placeholder",
    connectWith: ".connectedSortable",
    opacity: 0.7,
    helper: "clone",
    cursor: "move",
    update: function(event, ui) {
      var enclosure, room_id, params, template, url, new_items, item_id;
      enclosure = $(this).closest(".room");
      room_id = $(this).closest(".room").attr("id").match(/[^room_]/);
      params = enclosure.sortable("serialize") + "&room_id=" + room_id;
      template = Handlebars.compile($("script[name=registration_snapshot_template]").html());
      //url = "/trips/#{@trip.id}/schedule/sort_room.json";
      url = "/trips/1/schedule/sort_room.json";
      $.getJSON(url, params, function(data) {
        enclosure.html(template(data));

        // ugly hack to stop moved items from re-rendering in the source column
        //$("#room_"+room_id).find("#"+ui.item.attr("id")).remove();

        markBilateral();
      });
    }
  }).disableSelection();

  $("#unscheduled.connectedSortable").sortable({
    items: ".sortable",
    placeholder: "registration_order_placeholder",
    connectWith: ".connectedSortable",
    opacity: 0.7,
    helper: "clone",
    cursor: "move",
    update: function(event, ui) {
      var enclosure, params, template, url;
      enclosure = $(this).closest(".registrations");
      params = enclosure.sortable("serialize");
      template = Handlebars.compile($("script[name=registration_snapshot_template]").html());
      //url = "/trips/#{@trip.id}/schedule/sort_unscheduled.json";
      url = "/trips/1/schedule/sort_unscheduled.json";
      $.getJSON(url, params, function(data) {
        enclosure.html(template(data));

        // ugly hack to stop moved items from re-rendering in the source column
        // $("#unscheduled").find("#"+ui.item.attr("id")).remove();

        markBilateral();
      });
    }
  }).disableSelection();

  function markBilateral() {
    $(".registration.bilateral").find("span.asterisk").remove();
    $(".registration.bilateral h3").append('<span class="asterisk">[bilateral]</span>');
  }

});
