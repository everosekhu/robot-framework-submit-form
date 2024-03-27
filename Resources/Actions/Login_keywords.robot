*** Settings ***
Resource            ../Elements/Login_variables.robot



*** Keywords ***

The User Visits Optimy Automation Page
    Open Browser                        ${URL}          ${BROWSER}
    Maximize Browser Window
    Close Browser Cookie Popup
    Wait Until Element Is Visible       ${loginBtn}


The User Clicks Login
    Close Browser Cookie Popup
    Click Element                       ${loginBtn}


The Login Elements Are Present
    Wait Until Element Is Visible       ${usernameField}
    Wait Until Element Is Visible       ${passwordField}
    Wait Until Element Is Visible       ${submitLogin}


The User Enters Login Credentials
    [Arguments]         ${username}=${USERNAME}         ${password}=${PASSWORD}

    The Login Elements Are Present
    Input text          ${usernameField}                ${username}
    Input text          ${passwordField}                ${password}


The User Submits Login Form
    Click Element       ${submitLogin}


Close Browser Cookie Popup
    sleep   2
    ${present}=     Run Keyword And Return Status    Element Should Be Visible   ${cookieCloseBtn}
    Run Keyword If    ${present}
    ...     Click Element       ${cookieCloseBtn}