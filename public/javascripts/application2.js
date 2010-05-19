// public/javascripts/application2.js
// 
// by (zpc) indro.de@gmail.com

function toggleMask(a, b) {
	a = document.getElementById(a);
	box = document.getElementById(b);
	if (box.checked) {
		a.setAttribute('type','text');
    }
	else { 
		a.setAttribute('type','password');
  }
  a.focus();
}



function confirm(msg, callback) {
  $('#confirm')
    .jqmShow()
    .find('p.jqmConfirmMsg')
      .html(msg)
    .end()
    .find(':submit:visible')
      .click(function(){
        if(this.value == 'yes')
          (typeof callback == 'string') ?
            window.location.href = callback :
            callback();
        $('#confirm').jqmHide();
      });
}




// document.ready starts here -----------------------------------------------------
$(document).ready(function() {
	
	//slider
	$('#slider').loopedSlider({
		//addPagination: true,
		autoStart: 4000,
		slidespeed: 600,
		containerClick: false,
		container: ".slides_container"
	});
	
	//show-hide links
	$('p.answer').hide();
	$('a.showhide').click(function(event) {
		event.preventDefault();
		var id = $(this).attr('id');
		//console.log('#a_' + id);
		$('#a_' + id).slideToggle();	
	});


	$('#confirm').jqm({overlay: 60, modal: true, trigger: false});
	
	// trigger a confirm whenever links of class alert are pressed.
	$('a.confirm').click(function() { 
	  //console.log(this.href);
		confirm('Are you sure?', this.href); 
	  return false;
	});

	//console.log("animate flash");
	//$("#flash_space").effect("highlight", {}, 800);
	//$("#flash_space").pause(7000).slideUp();
	//$("#flash_notice").pause(7000).slideUp();			
	
	
	$("#flash_notice a").bind('click', function() {
		//console.log("up");
		$("#flash_space").stop();
		$("#flash_notice").stop();
		$("#flash_space").slideUp();
		$("#flash_notice").slideUp();
		return false;	
	});

	// make share divs unobtrusive (show by default, then hide)
	$(".share_content").hide();
	
	// show upcoming tasks
	$('div#div_share_upcoming').show();
		
	// share page tabbed menu
	$("#sharemenu a").click(function(event){
		event.preventDefault();
		$("#tabmenu a").removeClass('current');
		$(this).addClass('current');
		var cur = $(this).attr('id');			
		//console.log(cur);
		$('div.share_content').hide();
		$('div#div_'+cur).show();
	});
	


	// add more magic here

	
})
// document.ready ends here -----------------------------------------------------


$.fn.pause = function(duration) {
    $(this).animate({ dummy: 1 }, duration);
    return this;
};