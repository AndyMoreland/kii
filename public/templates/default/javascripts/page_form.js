$(function(){
  var authenticityToken = $("input[name=authenticity_token]").val()
  
  //////////////////////////////
  // AJAX Previews
  //
  $("#page_form_tabs div:first").addClass("active");
  
  // Handiling active tab color
  $("#page_form_tabs div").click(function(){
    $("#page_form_tabs div").removeClass("active");
    $(this).addClass("active");
  });
  
  // The show form tab
  $("#show_form").click(function(){
    $("#page_form").show();
    $("#page_preview").hide();
  })
  
  // The show preview tab
  $("#show_preview").click(function(){
    $("#page_preview_loading").show();
    $("#page_preview_content").html("");
    $("#page_preview_error").hide();
    
    
    $("#page_form").hide();
    $("#page_preview").show();
    
    var data = {}
    
    // All the form fields! This will also include the preview
    // submit button, causing the controllers to render the
    // preview instead of saving the record.
    $("#page_form :input").each(function(i, elem){
      var obj = $(elem);
      data[obj.attr("name")] = obj.val();
    });
    
    $.ajax({
      type: "POST",
      url: $("#page_form").attr("action"),
      data: data,
      success: function(data){
        $("#page_preview_content").html(data)
        $("#page_preview_loading").hide();
      },
      error: function(){
        $("#page_preview_error").show();
      },
      complete: function(){
        $("#page_preview_loading").hide();
      }
    })
  })
  
  // We don't want the none-JS preview button.
  $("#page_form input[type=submit][name=preview]").hide();
});