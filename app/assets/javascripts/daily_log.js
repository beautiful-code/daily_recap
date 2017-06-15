function DailyLog() { 
  $(document).ready(function() {
    var add_task      = $(".add_field_button");
    $(add_task).click(function(e){
      $('.task').append("<br><input type='text'  class='form-control' maxlength='300' name='projects[]LogText[]' placeholder='  enter LogEntry' required='required' ></input>")
      
    });

    var add_project      = $(".add_project_button");
    $(add_project).click(function(e){
      $('.project').append("<hr><div class='form-group'><select class='added'></select> <br> <h3>Task</h3><input class='form-control' name='projects[]LogText[]'  maxlength='300' placeholder='enter LogEntry' required='required' type='textarea'></div><div><button class='btn btn-default add_field_button'>add more</button></div>");
            var attrid="projects[]";
            $('.added').attr('name', attrid).append($('#projects_').html());
    });
  $('input[name="daterange"]').daterangepicker();
});
$('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
  var project_id= $("#projects_filter").val();
$('.user_summary').load('/daily_logs/user_logs',{ start_date: picker.startDate.format('YYYY-MM-DD'), end_date: picker.endDate.format('YYYY-MM-DD'),"project_id": project_id});
});
$('select').change(alert_me_test);
function alert_me_test(){
  var project_id= $("#projects_filter").val();
$('.user_summary').load('/daily_logs/user_logs',{"project_id": project_id});
}
$('#context1 .menu .item')
  .tab({
    context: $('#context1')
  })
;
var today = new Date();
$('#example1').calendar({
  onChange: function (date, text) {
     var newValue = text;
     $('.dynamic').load('/daily_logs/refresh',{ "log_date":newValue});
  },
  type: 'date',
   maxDate: new Date(today.getFullYear(), today.getMonth(), today.getDate())
 })
$('.top.menu .item').tab({'onVisible':function(){
     var newValue = $(this).attr("dataval")
     $('.dynamic').load('/daily_logs/refresh',{ "log_date":newValue});
}}); 
$('.imageclass').on('click',function(){
  var userid=$(this).attr("id");
  $('.user_list').load('/daily_logs/user_logs',{"user_id":userid});
});

  

$('.secondary.menu .item').tab({'onVisible':function(){
  var x=$(this).attr('data-tab');
  if(x=="first")
    location.reload();

}}) ;   
};
     
