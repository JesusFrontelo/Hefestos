import os
import requests

def handler (event, context):
  
    # Defining variables and getting values from Lambda environment vars
    user = os.environ.get('USER')
    passw = os.environ.get('PASSWORD')
    protocol = "http://"
    url = os.environ.get('HOST')
    port = os.environ.get('PORT')
    path = os.environ.get('PATH')
    
    #Generating complete url with user and pass
    url_final=protocol + user + ":" + passw + "@" + url + ":" + port + path

    try:
      requests.get(url_final)
    except:
      print('ERROR')
    else:
      response=requests.get(url_final)
      if response.status_code is 200:
         print('OK')
         return ('OK')
      else:
         print('ERROR')
         return ('ERROR')