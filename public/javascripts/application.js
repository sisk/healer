$(document).ready(function() {
  // hack to fix the way Rails does authenticity_token output in form_for
  $("input[name=authenticity_token]").parent("div").hide();
});
