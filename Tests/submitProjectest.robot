*** Settings ***
Library             SeleniumLibrary
Resource            ../Resources/Actions/Login_keywords.robot
Resource            ../Resources/Actions/ApplicationForm_keywords.robot
Suite Setup         the user visits Optimy automation page      
Suite Teardown       Close Browser


*** Test Cases ***
Verify user can login
    Given the user clicks login
    And the user enters login Credentials
    When the user submits login form
    Then the user can see submit new application button

Verify user can submit application form
    Given the user clicks submit new application
    And the user clicks footer submit new application
    When the user fill-out all forms
    Then application form answers are in summary

Verify application submission is completed
    Given the user is viewing summary
    When the user clicks on validate and send button
    Then the user can see thank you

