*** Settings ***
Library     Collections
Library     RequestsLibrary
Library     OperatingSystem
Library     JSONLibrary
Library     os

*** Variables ***
${base_url}     https://gmb6od13qd.execute-api.ap-south-1.amazonaws.com/staging/api
${Aq-Auth-Token}    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjozMzcsInVzZXJfbmFtZSI6Ikt1c2hhbCBHb3dkYSBTIiwidXNlcl9lbWFpbCI6InNrdXNoYWxnb3dkYTE5OTZAZ21haWwuY29tIn0.jySccDnnnwDEucoTFD308wQ9XFNAgXxTrx9EyqjzMDs
${app-secret-token}     4668b758-0f0e-46f1-9284-67444ae460e8

*** Test Cases ***
TC1_register-user-adaccount-association (POST_Request)
    create session  session_1   ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}  Content-Type=application/json
    ${request_body}=    get file    D:/Robotframework_files/TC_1_Post.txt
    ${response_body}=   Post on session     session_1   /api/user/ad-accounts/register  data=${request_body}    headers=${headers}
    log to console      ${response_body.status_code}
    log to console      *****************************************************
    log to console      ${response_body.content}
    log to console      *****************************************************
    log to console      ${response_body.headers}
    log to console      *****************************************************

    #Validation for Response Status code and Response Body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_content}=    convert to string   ${response_body.content}
    should contain  ${response_content}     "error": false
    should contain  ${response_content}     "status": "success"

    #Validation for Headers and Cookies
    ${content_type_value}=  get from dictionary     ${response_body.headers}    Content-Type
    should be equal     ${content_type_value}       application/json

TC2_get_user_accessible_adaccounts (Get_Request)
    create session  session_2   ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}
    ${response_body}=   get on session  session_2   /api/user/ad-accounts    headers=${headers}
    ${json_object}=     to json     ${response_body.content}
    Log to console      ${response_body.status_code}
    Log to console      ${response_body.content}

    #Validation of response status code
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200

    #Validation of the JSON Response Body
    ${error_message}=     get value from json     ${json_object}      $.error
    log to console  *****************************************************************
    log to console      ${error_message}
    should not be equal     ${error_message}    true
    ${ad_account}=  get value from json     ${json_object}      $.data.adaccounts[0]
    log to console  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    log to console      ${ad_account[0]}
    should contain     ${ad_account[0]['ad_account_name']}     QA Testing

TC3_get_subscription_status (GET)
    create session  session_3  ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}
    ${response_body}=    get on session  session_3  /api/subscription/36/payment/status    headers=${headers}
    Log to console      ${response_body.status_code}
    Log to console      ${response_body.content}

    #Validation of response status code and response body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_body}=   convert to string   ${response_body.content}
    should contain  ${response_body}     "error": false

TC4_upsert_optimizer (POST)_Negative_Scenario
    create session  session_4   ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}  Content-Type=application/json
    ${request_body}=     get file    D:/Robotframework_files/TC_2_Post.txt
    ${response_body}=   post on session    session_4   /api/optimiser  data=${request_body}    headers=${headers}
    log to console      ${response_body.status_code}
    log to console      ${response_body.content}
    log to console      ${response_body.headers}

    #Vaildation of response status code and response body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_body}=   convert to string   ${response_body.content}
    should contain  ${response_body}     "error": false
    should contain  ${response_body}    "status": "success"

    #Validation of headers and Cookies
    ${content_type_value}=      get from dictionary     ${response_body.headers}     Content-Type
    should be equal     ${content_type_value}       application/json

TC5_add_Kill_switch_id (POST)
    create session  session_5   ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}  Content-Type=application/json
    ${request_body}=     get file    D:/Robotframework_files/TC_3_Post.txt
    ${response_body}=   post on session    session_5    /api/kill-switch/associate   data=${request_body}    headers=${headers}
    log to console      ${response_body.status_code}
    log to console      *****************************************************
    log to console      ${response_body.content}
    log to console      *****************************************************
    log to console      ${response_body.headers}
    log to console      *****************************************************

    #Vaildation of response status code and response body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_content}=   convert to string   ${response_body.content}
    should contain  ${response_content}     "error": false
    should contain  ${response_content}    "status": "success"

    #Validation of headers and Cookies
    ${content_type_value}=      get from dictionary     ${response_body.headers}     Content-Type
    should be equal     ${content_type_value}       application/json

TC6_get_adaccount_optimizer (GET)
    create session  session_6   ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}
    ${params}   create dictionary   ad_account_fb_id=2539692029655297   level_of_execution=C    is_active=1     return_detailed_response=True
    ${response_body}=   get on session  session_6   /api/optimiser/all?     headers=${headers}  params=${params}
    Log to console      ${response_body.status_code}
    Log to console      ${response_body.content}

    #Validation of response status code and response body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_body}=   convert to string   ${response_body.content}
    should contain  ${response_body}     "error": false

TC7_latest_sync_job_log_id (GET)
    create session  session_7  ${base_url}
    ${headers}  create dictionary   Aq-Auth-Token=${Aq-Auth-Token}  App-Secret-Token=${app-secret-token}
    ${response_body}=    get on session  session_7  /publicapi/syncjoblog/optimizer/latest   headers=${headers}
    Log to console      ${response_body.status_code}
    Log to console      ${response_body.content}

    #Validation of response status code and response body
    ${status_code}=     convert to string   ${response_body.status_code}
    should be equal     ${status_code}  200
    ${response_body}=   convert to string   ${response_body.content}
    should contain  ${response_body}     "error": false
    should contain  ${response_body}    "latest_sync_job_log_id"

