jQuery.expr[':'].contains = function(a,i,m){
  // override jQuery.contains for case-insensitivity
  return $(a).text().toUpperCase().indexOf(m[3].toUpperCase())>=0;
};

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
      var item_id;
      item_id = ui.item.attr("id");
      updateRoom($(this));
      if (ui.sender) {
        // stop moved items from re-rendering in the source column
        ui.sender.find("#"+ui.item.attr("id")).remove();
      }
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
    },
    update: function(event, ui) {
      var item_id;
      item_id = ui.item.attr("id");
      updateUnscheduled();
      if (ui.sender) {
        // stop moved items from re-rendering in the source column
        ui.sender.find("#"+ui.item.attr("id")).remove();
      }
      $("#"+item_id).flash();
    }
  }).disableSelection();

  $("#unscheduled_filter").keyup(function(){
    var query;
    query = $(this).val();
    $("#source .registration").hide();
    $("#source .registration:contains('"+query+"')").show();
    //$("#generated_fld").val($(this).val()).keyup();
    // $("div:contains('John')")
  });
  
});

function updateUnscheduled() {
  var params, template, url;
  params = $("#unscheduled").sortable("serialize");
  // $("#unscheduled").html('<img class="ajax_loader" src="/images/ajax-loader.gif" />');
  $.ajax({
    url: "/trips/1/schedule/sort_unscheduled",
    type: "PUT",
    data: params
  });
  $("#unscheduled").toggle_empty_class();
}

function updateRoom(element) {
  var enclosure, room_id, day_num, params, template, url;
  enclosure = element.closest(".room");
  room_id = element.closest(".room").attr("class").match(/room_(\d+)/)[1];
  day_num = element.closest(".room").attr("class").match(/day_(\d+)/)[1];

  params = enclosure.sortable("serialize") + "&room_id=" + room_id + "&day=" + day_num;
  // enclosure.html('<img class="ajax_loader" src="/images/ajax-loader.gif" />');
  $.ajax({
    url: "/trips/1/schedule/sort_room",
    type: "PUT",
    data: params
  });
  enclosure.toggle_empty_class();
}