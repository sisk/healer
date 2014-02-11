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
