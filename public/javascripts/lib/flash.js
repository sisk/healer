jQuery.fn.flash = function( background_color, duration ) {
  var current, background_color, duration;
  current = $(this).css( 'background-color' );
  background_color = background_color || "#fffd99";
  duration = duration || 1500;
  $(this).animate( { backgroundColor: background_color }, duration / 2 );
  $(this).animate( { backgroundColor: current }, duration );
}