function EditLog() {
  $(document).delegate('.add_field_button', 'click', function()
    {
      var project_id= $(this).parent().parent().children().eq(0).children().val();
      if(project_id=="")
      {
        var project_id= $(this).parent().parent().children().eq(0).children().attr("value");
      }

      $(this).parent().children().eq(0).append("<input type='text'  class='form-control NewlyAdded' maxlength='300' name='NewLogtext["+project_id+"][]' placeholder='enter LogEntry' required='required' ></input><br>");
    });
  $(document).delegate('.added', 'change', function()
    {
      var project_id =$(this).val();
      if(project_id=="")
      {
        project_id= $(this).attr("value");
      }
      var name= 'NewLogtext['+project_id+'][]';
      $(this).parent().parent().children().eq(2).children().eq(0).children().filter('.NewlyAdded').attr('name',name);
      $(this).parent().parent().children().eq(2).children().eq(0).children().filter('.existing').each(function(i){
        var oldName= $(this).attr('name');
        var newName='Logtext['+project_id+']'+oldName.substring(oldName.lastIndexOf('['));
        $(this).attr('name',newName);
      });
      //$(this).next().next().next().children().filter('.form-control').attr('name',name);
    });
  $(document).delegate('.add_project_button','click',function()
    {
       var value= $('#projects_').attr('value');
      var attrid ="projects[]"
      $('.project').append("<div><div><select class='newproject added' required='required' value ='"+value+"'></select></div><h5 class ='task'>Task</h5><div><div><input type='text' class ='form-control NewlyAdded' maxlength='300' placeholder='enterLogEntry' required='required'></input></br></div><button class ='btn btn-default add_field_button'>Add Task</button></div></div>");
      $('.newproject').attr('name',attrid).append($('#projects_').html());
      $('.newproject').removeClass('newproject')
    });
};

