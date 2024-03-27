*** Settings ***
Library                 String
Library                 Collections
Library                 OperatingSystem
Resource                ../Elements/ApplicationForm_variables.robot



*** Keywords ***

The User Clicks Submit New Application
    Click Element       ${submitNewAppBtn}


The User Can See Submit New Application Button
    Wait Until Element Is Visible       ${submitNewAppBtn}


The User Clicks Footer Submit New Application
    sleep   2
    ${present}=         Run Keyword And Return Status    Element Should Be Visible   ${footerSubmitNewAppBtn}
    Run Keyword If      ${present}
    ...     Click Element       ${footerSubmitNewAppBtn}


The User Fill-out All Forms
    ${num}=                 Generate Random Number
    &{ANSWERS}              Create Dictionary
    Set Test Variable       ${ANSWERS}          &{ANSWERS}
    Input Fullname          ${num}
    Input Address           ${num}
    Upload Photo
    Select Random Gender
    Select Random Role
    Select Random Tools Frameworks and Programming Language
    Input Objective
    Click Element           ${nextScreenBtn}


Generate Random Number
    ${num} =  Generate Random String  8  [NUMBERS]
    [Return]        ${num}
    

Input Fullname
    [Arguments]         ${num}
    Wait Until Element Is Visible               ${firstNameField}
    Input Text          ${firstNameField}       First${num}         True
    Input Text          ${lastNameField}        Last${num}          True
    Set To Dictionary   ${ANSWERS}              firstname=First${num}
    Set To Dictionary   ${ANSWERS}              lastname=Last${num}


Input Address
    [Arguments]         ${num}
    ${street} =         Set Variable            ${num} Nowhere Street
    ${zip} =            Set Variable            1000
    Set To Dictionary   ${ANSWERS}              street=${street}
    Set To Dictionary   ${ANSWERS}              postal=${zip}
    Input Text          ${houseNumTextarea}     ${street}           True
    Input Text          ${postalField}          ${zip}              True
    Select First Postal Menu Item
    Select Random Country


Select First Postal Menu Item
    Wait Until Element Is Visible               ${postalMenuItem}
    sleep   1
    Click Element       ${postalMenuItem}


Select Random Country
    ${index} =          Generate Random Index       ${countrySelectOption}
    Select From List By Index                       ${countrySelect}      ${index}
    ${country}          Get Selected List Label     ${countrySelect}
    Set To Dictionary   ${ANSWERS}                  country=${country}


Generate Random Index
    [Arguments]         ${el}
    Wait Until Element Is Visible                   ${el}
    ${count} =          Get Element Count           ${el}
    ${index} =          Evaluate                    random.randint(1, (${count} - 1))
    [Return]            ${index}


Upload Photo
    ${uploadFilePath}           Normalize Path          ${CURDIR}/../Files/camera.jpeg
    Choose File                 ${photoUploadBtn}       ${uploadFilePath}
    Set To Dictionary           ${ANSWERS}              photo=camera.jpeg


Select Random Gender
    Wait Until Element Is Visible               ${genderRadio}
    ${index} =      Evaluate                    random.randint(1, 3)
    ${gender} =     Get Text                    ${genderRadio}:nth-child(${index})
    Click Element           ${genderRadio}:nth-child(${index})
    Set To Dictionary       ${ANSWERS}          gender=${gender}


Select Random Role
    ${index} =      Generate Random Index       ${roleSelectOption}
    Select From List By Index                   ${roleSelect}      ${index}
    ${role}         Get Selected List Label     ${roleSelect}
    Set To Dictionary       ${ANSWERS}          role=${role}


Select Random Tools Frameworks and Programming Language
    ${numTools} =       Evaluate                random.randint(1, 5)
    ${toolsList} =      Create List

    Wait Until Element Is Visible               ${toolsCheckbox}
    ${count} =          Get Element Count       ${toolsCheckbox}
    FOR    ${number}    IN RANGE    ${numTools}
        ${index} =          Evaluate            random.randint(1, ${count})
        ${tool} =           Get Text            ${toolsCheckbox}:nth-child(${index})
        ${status} =         Run Keyword And Return Status       List Should Not Contain Value      ${toolsList}    ${tool} 
        IF   ${status}
            Click Element       ${toolsCheckbox}:nth-child(${index})
            Append To List      ${toolsList}        ${tool}
        END
    END
    Set To Dictionary       ${ANSWERS}          tools=${toolsList}

    
Input Objective
    ${num} =                Generate Random Number
    ${objective} =          Set Variable        Just random objective${num}
    Select Frame            ${objectiveIframe}      
    Click Element           ${objectiveIframeBody}
    Clear Element Text      ${objectiveIframeBody}
    Input Text              ${objectiveIframeBody}      ${objective}
    Unselect Frame
    Set To Dictionary       ${ANSWERS}                  objective=${objective}


Application Form Answers are in Summary
    Wait Until Element Is Visible               ${answerSection}
    ${fname} =          Evaluate                ${ANSWERS}.get('firstname')
    ${lname} =          Evaluate                ${ANSWERS}.get('lastname')
    ${street} =         Evaluate                ${ANSWERS}.get('street')
    ${postal} =         Evaluate                ${ANSWERS}.get('postal')
    ${country} =        Evaluate                ${ANSWERS}.get('country')
    ${photo} =          Evaluate                ${ANSWERS}.get('photo')
    ${gender} =         Evaluate                ${ANSWERS}.get('gender')
    ${role} =           Evaluate                ${ANSWERS}.get('role')
    ${tools} =          Evaluate                ${ANSWERS}.get('tools')
    ${objective} =      Evaluate                ${ANSWERS}.get('objective')
    
    Wait Until Element Contains     ${answerFirstname}           ${fname}           30
    Wait Until Element Contains     ${answerLastname}           ${lname}
    Wait Until Element Contains     ${answerStreet}             ${street}
    Wait Until Element Contains     ${answerPostal}             ${postal}
    Wait Until Element Contains     ${answerCountry}            ${country}
    Wait Until Element Contains     ${answerPhoto}              ${photo}
    Wait Until Element Contains     ${answerGender}             ${gender}
    Wait Until Element Contains     ${answerRole}               ${role}
    Wait Until Element Contains     ${answerObjective}          ${objective}
    Scroll Element Into View        ${answerTools}:nth-child(1)
    FOR  ${item}  IN  @{tools}
        Wait Until Element Contains     css=.section .question.question-checkbox          ${item}         30
    END


The User Is Viewing Summary
    Wait Until Element Contains     ${summaryHeader}            Summary


The User Clicks on Validate and Send Button
    Wait Until Element Is Visible           ${validateSendBtn}
    Click Element                           ${validateSendBtn}


The User Can See Thank You
    Wait Until Element Contains     ${thankYouTxt}              Thank you for submitting your project
