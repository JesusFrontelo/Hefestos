<div align="center">

  <img align="center" height="90" width="120" src="https://docs.microsoft.com/es-es/powershell/media/index/ps_black_128.svg" /> 
  <h1> Scripts POWERSHELL </h1>

<table>
  <tr>
    <th> SCRIPT </th>
    <th> DESCRIPTION </th>
  </tr>
  <tr>
    <td> Logrotate_Windows.ps1 </td>
    <td> Erase files from a folder wich has files older than specified at prompt since "today", and creates a scheduled task wich executes every day at 9am </td>
  </tr>
  <tr>
    <td> Log_Off_Disconected_users.ps1 </td>
    <td> Disconnects all the users in the windows server wich didn´t closed right their sessions. Be carefull, if the user has running processes it forces them to end. </td>
  </tr>  
  <tr>
    <td> create_user.ps1 </td>
    <td> Creates a user in the system, and put it into the admins group. Sets the WinRM to basic auth. This script be usefull if you´re planning to create an ansible user in multiple servers. </td>
  </tr>    
</table>

</div>
