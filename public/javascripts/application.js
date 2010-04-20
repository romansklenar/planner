// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

Ajax.Responders.register({
  onCreate: function(){
    $('indicator').show();
  },
  onComplete: function() {
    if(Ajax.activeRequestCount == 0)
      $('indicator').hide();
  }
});