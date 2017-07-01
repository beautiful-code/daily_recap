function DailyLog() {
  $(document).delegate('.add_field_button', 'click', function()
    {
      var project_id= $(this).parent().parent().children().eq(0).val();
      $(this).parent().children().eq(1).append("<br><input type='text'  class='form-control' maxlength='300' name='log_entry["+project_id+"][]' placeholder='enter LogEntry' required='required' ></input>");
    });
  $(document).delegate('.add_project_button', 'click', function()
    {
      $('.project').append("<hr><div class='form-group'><select class='newproject added' required='required'></select> <br> <h5 class ='task'>Task</h3><div><input class='form-control'  maxlength='300' placeholder='enter LogEntry' required='required' type='textarea'><div></div><br><button class='btn btn-default add_field_button'>Add Task</button></div>");
      var attrid="projects[]";
      $('.newproject').attr('name',attrid).append($('#projects_').html());
      $('.newproject').removeClass('newproject');
    });

  $(document).ready(function() {
    $('input[name="daterange"]').daterangepicker();
  });
  $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
    var project_id= $("#projects_filter").val();
    $('.user_summary').load('/daily_logs/user_logs',{ start_date: picker.startDate.format('YYYY-MM-DD'), end_date: picker.endDate.format('YYYY-MM-DD'),"project_id": project_id});
  });
  $('.projects_filter').change(alert_me_test);
  function alert_me_test(){
    var project_id= $("#projects_filter").val();
    var datepicker = $('input[name="daterange"]').data('daterangepicker');
    var today=moment().format('DD-MMM-YYYY');
    if(datepicker.startDate.format('DD-MMM-YYYY')==today)
    {
      $('.user_summary').load('/daily_logs/user_logs',{"project_id": project_id});
    }
    else
    {
      $('.user_summary').load('/daily_logs/user_logs',{start_date:datepicker.startDate.format('YYYY-MM-DD'),end_date:datepicker.endDate.format('YYYY-MM-DD'),"project_id": project_id});
    }
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
    // TODO dont you need to put semi colon at EOL
    var newValue = $(this).attr("dataval")
    $('.dynamic').load('/daily_logs/refresh',{ "log_date":newValue});
  }});
  $('.imageclass').on('click',function(){
    var userid=$(this).attr("id");
    $('.user_list').load('/daily_logs/user_logs',{"user_id":userid});
  });

  $('.secondary.menu .item').tab({'onVisible':function(){
    // TODO use proper variable names
    var x=$(this).attr('data-tab');
    if(x=="first")
      location.reload();

  }}) ;
  // $('.added').change(function() {
  $(document).delegate('.added', 'change', function()
    {
      var project_id =$(this).val();
      var name= 'log_entry['+project_id+'][]';
      $(this).next().next().next().children().eq(1).children().filter('.form-control').attr('name',name);
      $(this).next().next().next().children().filter('.form-control').attr('name',name);
    });
};

