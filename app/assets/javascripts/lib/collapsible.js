(function($){
  $.fn.collapsible = function() {
    expandedItems = JSON.parse(localStorage.getItem("expandedItems")) || {};

    // Reopen left open tabs.
    for (var prop in expandedItems) {
      if(expandedItems.hasOwnProperty(prop)) {
        $("#" + prop).removeClass("collapsed");
        $("#" + prop).find(".supplement").toggle();
      }
    }

    var toggle_trigger = $(this).find(".basic");
      toggle_trigger.bind('click', function(event) {
        expandedId = event.currentTarget.parentNode.id;
        if ($(this).parent().hasClass("collapsed")) {
          $(this).parent().removeClass("collapsed");
          expandedItems[expandedId] = true;
        } else {
          $(this).parent().addClass("collapsed");
          delete expandedItems[expandedId];
        }
        $(this).siblings(".supplement").toggle();

        localStorage.setItem("expandedItems", JSON.stringify(expandedItems));
      }
    );
    return this;
  }
}(jQuery));

$(".collapsible").collapsible();