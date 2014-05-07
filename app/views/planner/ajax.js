$('#tbutton').click(function() {
	$.ajax({
	url: 'page.html',
	success: function(data) {
		$('#test').html(data);
		}
	
	});