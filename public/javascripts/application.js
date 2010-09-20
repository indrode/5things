// public/javascripts/application.js
// by (zpc) indro.de@gmail.com

//$.ui.dialog.defaults.bgiframe = true;

var curState = true;
var submitted = false;

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {
	xhr.setRequestHeader("Accept", "text/javascript")
	}
})

jQuery.fn.submitWithAjax = function() {
  this.submit(function() {
		var id = $(this).attr('id');
		var check = $(this).attr('id') + '_value';
		var curVal = $('#'+check).val();
		if($.trim(curVal)!='' && submitted == false) {
			submitted = true;
			$(':text').attr("readonly", "readonly");
			$('#loader_'+id).addClass('loading');
    	$.post(this.action, $(this).serialize(), null, "script");
			//console.log(AUTH_TOKEN);
		}
    return false;
  })
  return this;
};


// prevent double-submit
// sets global var submitted to false every 3 seconds
function resetSubmitted() {
	submitted = false;
	//console.log('reset');
}
var submitInterval = setInterval(resetSubmitted, 2000);






/* German initialisation for the jQuery UI date picker plugin. */
/* Written by Milian Wolff (mail@milianw.de). */

jQuery(function($){
	$.datepicker.regional['de'] = {
		closeText: 'schließen',
		prevText: '&#x3c;zurück',
		nextText: 'vor&#x3e;',
		currentText: 'heute',
		monthNames: ['Januar','Februar','März','April','Mai','Juni',
		'Juli','August','September','Oktober','November','Dezember'],
		monthNamesShort: ['Jan','Feb','Mär','Apr','Mai','Jun',
		'Jul','Aug','Sep','Okt','Nov','Dez'],
		dayNames: ['Sonntag','Montag','Dienstag','Mittwoch','Donnerstag','Freitag','Samstag'],
		dayNamesShort: ['So','Mo','Di','Mi','Do','Fr','Sa'],
		dayNamesMin: ['So','Mo','Di','Mi','Do','Fr','Sa'],
		weekHeader: 'Wo',
		dateFormat: 'yy/mm/dd',
		firstDay: 1,
		isRTL: false,
		showMonthAfterYear: false,
		yearSuffix: ''};
	$.datepicker.setDefaults($.datepicker.regional['de']);
});



var toggleCheck = function() {
	//console.log('toggleCheck');
	//console.log(curState);
	if (curState) {
		var state = $(this).attr('class');
		var status = 0;
		$(this).removeClass();
		if (state == "ui-state-checked") {
  			$(this).addClass("ui-state-default"); 
		} else {
			$(this).addClass("ui-state-checked");
			status = 1;
		}
		// update state in DB	
		var id = $(this).attr('id');
		//console.log(id);
		$.post('checkcompleted', '_method=put&completed='+status+'&authenticity_token='+AUTH_TOKEN+'&id='+id);
	}
};

var showTaskOptions = function(event) {
	if(event=="over") {
    $(this).find('img').css("visibility","visible");
		//console.log("show");
  }
	else {
    $(this).find('img').css("visibility","hidden");
		//console.log("hide");
	}
};


function no_click() { return false; }

// this function calls the find_today method every couple of second
// to update the "number of to-do tasks today"
function callMeOften()
{
     $.ajax({
                   method: 'get',
                   url : '/find_today',
                   dataType : 'text',
                   success: function (text) { $('#today_status').html(text); }
                });

}

// this specified how often the function is called
var holdTheInterval = setInterval(callMeOften, 30000);

$(document).ajaxSend(function(event, request, settings) {
  if (typeof(AUTH_TOKEN) == "undefined") return;
  // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
  settings.data = settings.data || "";
  settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
});


jQuery.fn.extend({ 
        disableSelection : function() { 
                this.each(function() { 
                        this.onselectstart = function() { return false; }; 
                        this.unselectable = "on"; 
                        jQuery(this).css('-moz-user-select', 'none'); 
                }); 
        } 
});






// document.ready starts here -----------------------------------------------------
$(document).ready(function() {
	

	var watermarkText = $('#new_unassigned_value').val();
	var curTool = "";

	// close default help
	// expand this to include future env_other settings
	$(".message a.close, .message a.close2").click(function(e){
		e.preventDefault();
		$(".message").fadeOut('medium');
		$.ajax({ method: 'get', url : '/set_help', dataType : 'text'});
	});

		
	// initialize tablesorter
	$("#tasktable").tablesorter({ 
		headers: { 3: { sorter: false} },		// do not sort legend column
		widthFixed: true });
//	  .tablesorterPager({container: $("#pager")
//	});


	
	$("#new_yesterday, #new_today, #new_tomorrow, #new_unassigned").livequery( function() {		
	  $(this).submitWithAjax();	
	});
	
	
	// tools
	$(".icon_item").click(function(){
		var id = $(this).attr("id").substr(4);
		//console.log(id);
		$(".toolbox").slideUp();
		if (curTool != id) {
			$("#"+id).slideToggle('medium');
			curTool = id;
		} else {	
			curTool = "";
		}
		return false;
	});

	
	
	
	// autocomplete feature
	//$(".taskbox").livequery( function(i) {
	//	$('#new_unassigned_value, #new_yesterday_value, #new_today_value, #new_tomorrow_value').autocomplete({
	//		source: availableTags,		
	//		minLength: 3
	//	});	
	//});

	

	// submit links with ajax to dynamically update main_div
	$('#navleft a, #navright a, a#navhome').live("click", function () {
		$('#loader').addClass('loading');    
    $.get(this.href, null, null, 'script');  
    return false;  
	});

	// datepicker change month
	$('.ui-datepicker-prev', '.ui-datepicker-prev').live("click", function () {
		//$('#loader').addClass('loading');    
    $.get(this.href, null, null, 'script');  
    return false;  
	});	
	
	

	// date picker
	// get current i18n from hidden field which is populated with @today
	$("#showhide_datepicker").click(function(){
		$("#datepicker").slideToggle();
	});
	
	$.datepicker.setDefaults($.datepicker.regional['en']);			
	$('#datepicker').datepicker({
		numberOfMonths: 4,
		onSelect: function(dateText, inst) {
			// should open page and send querystring
			var newDate = $.datepicker.formatDate('yy-mm-dd', new Date(dateText));
			//console.log(newDate);
			window.location = '/home?d='+ newDate;
		}
	});

	//console.log("animate flash");
	$("#flash_space").effect("highlight", {}, 800);
	$("#flash_space").pause(5000).slideUp();
	$("#flash_notice").pause(5000).slideUp();			
	
	
	$("#flash_notice a").livequery('click', function() {
		//console.log("up");
		$("#flash_space").stop();
		$("#flash_notice").stop();
		$("#flash_space").slideUp();
		$("#flash_notice").slideUp();
		return false;	
	});

	// using live event binding to bind events to future items
	// http://kylefox.ca/blog/2009/feb/09/live-event-binding-jquery-13/
	$("li.ui-state-default").live('click', toggleCheck);
	$("li.ui-state-checked").live('click', toggleCheck);

  $('a.edit_task').livequery('click', function() {
		// what to do on edit
		var id = $(this).attr('id');

		// disable toggle check while editing
		curState = false;		
		$('#a' + id + ' span.inplace').trigger('make_editable');
		
		return false;		// prevent propagation	     
  });


	$(".inplace").livequery( function(i) {
	  $(this).editable("update", {
	  	type      : 'text',
			method		: 'PUT',
			cssclass : 'inline_edit',
//	  	name : $(this).attr('name'),
			name : 'body',			
			onblur : 'cancel',
			height: 16,
			width 		: 140,
			onreset: setState,
//			indicator : "<img src='/images/spinner.gif' />",  	
			event     : 'make_editable',
			submitdata : function(value, settings) {
				curState = true;
			}
						
		})
	});

	// run with onreset:-> make toggleCheck possible
	function setState() {
	   curState = true;
	}


	// toggle nav panel	
	$("#showhide_button").click(function(){
		//$("#user_nav").slideToggle();			
		$("#view_nav").slideToggle();
		$(".toolbox").slideUp();
		var el = $("#shText");  
		var state = $("#shText").html();
		state = (state == 'Close Tools' ? '<span id="shText">View Tools</span>' : '<span id="shText">Close Tools</span>');					
		el.replaceWith(state);
		curTool = "";	// reset current toolbar selection
		return false;
	});
	
	// sortable
	// use livequery to bind dynamic items
  $("ul.active").livequery(function() { 	
		$(this).sortable({
			connectWith: 'ul',
			cursorAt: { cursor: 'move', top: 10, left: 90 },
			items: 'li:not(.clean)',
			scroll: false, 
			//helper: 'clone',
			placeholder: 'ui-state-highlight',
			delay: 125,
			
			// prevent sortable from firing a click event
			update: function(event, ui) {	
				var newdate = $(this).attr('lang');
				if (newdate=='') {
					newdate = '1900-01-01';
				}	
			  $.post('sort', '_method=put&date='+newdate+'&authenticity_token='+AUTH_TOKEN+'&'+$(this).sortable('serialize'));
				$(this).find('img').css("visibility","hidden");				
				ui.item.unbind("click");
				ui.item.one("click", function (event) {
					event.stopImmediatePropagation();
					//$(this).click(toggleCheck);	
					$(this).live('click', toggleCheck);
				}); 	 
			}
		});		
	});	

 	$("li.ui-state-default").disableSelection();
	$("li.ui-state-checked").disableSelection();
	$("#lists").disableSelection();
	$("h2").disableSelection();


	$('#headerarea, #footerarea').droppable({
		accept : 'li.ui-state-default, li.ui-state-checked',
		hoverClass: 'drophover',
		drop: function(event, ui) {
			var id = $(ui.draggable).attr('id')	;
			//console.log(id);
			$.post('destroytask', '_method=put&authenticity_token='+AUTH_TOKEN+'&id='+id);
    	// remove element from where it came from
			$(ui.draggable).effect('explode');
			//$(ui.draggable).remove(); 
		}
	});


	// show tooltip when hovering iconmenu item
	$('li.icon_item').hover(function(){
		var id = $(this).attr('id');
		var content = $('#'+id).find('span').html();
		$('#iconmenu_description').empty();
		$('#iconmenu_description').append(content);		
	},
	 	function () {
			$('#iconmenu_description').empty();
			$('#iconmenu_description').append('<strong>5things - The Simple Task Manager</strong><br />click on an icon to select a function');		
	});




	// using http://cherne.net/brian/resources/jquery.hoverIntent.html
	// to prevent firing too many ajax calls on mouseover
	// http://rndnext.blogspot.com/2009/02/jquery-live-and-plugins.html
	
	$('li.ui-state-default, li.ui-state-checked').livequery('mouseover', function() {
      if (!$(this).data('init'))  
      {  
          $(this).data('init', true);  
          $(this).hoverIntent  
          (  
              function() {  
								$(this).find('img').css("visibility","visible");  
              },  
							function() {  
                $(this).find('img').css("visibility","hidden");  
              }
          );  
          $(this).trigger('mouseover');  
      }  
  });


	// watermark
	$(".taskbox").livequery('focus', function() {	
	    $(this).filter(function() {
	        // watermarkText is default watermark (depends on i18n)
	        // check if something new is entered
	        return $(this).val() == "" || $(this).val() == watermarkText;  
	    }).removeClass("watermarkOn").val("");
	});
  
	$(".taskbox").livequery('blur', function() {  
	    $(this).filter(function() {
	        return $(this).val() == ""  
	    }).addClass("watermarkOn").val(watermarkText);  
	});




	// dropdown
	
	$(document).click(function(){
	    $("ul.menu_body").hide();
	});
	

	$("ul.menu_body li:even").addClass("alt");
	
	$('#menu_head').click(function (e) {
		e.stopPropagation();
		$('ul.menu_body').slideToggle('medium');
	});

	
})
// document.ready ends here -----------------------------------------------------


$.fn.pause = function(duration) {
    $(this).animate({ dummy: 1 }, duration);
    return this;
};

