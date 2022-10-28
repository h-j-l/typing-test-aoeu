*** Settings ***
Documentation       Typing Test @ AOEU

Library             RPA.Browser.Selenium
Library             RPA.FileSystem


*** Variables ***
${SCORE_FILE}       ${OUTPUT_DIR}${/}score.txt
${URL}              https://typing-speed-test.aoeu.eu/


*** Tasks ***
Typing test
    Open the test in browser
    Close cookie popup
    Type the words
    Save the score
    [Teardown]    End test


*** Keywords ***
Open the test in Browser
    Open Available Browser    ${URL}
    Maximize Browser Window

Close cookie popup
    Click Button When Visible    css:button[mode="primary"][size="large"]

Type the words
    Wait For Condition    return document.readyState == "complete"
    ${currentWord}=    Get Text    id:currentword
    @{nextWords}=    Get WebElements    css:span[class="nextword"]
    Input Text    id:input    ${currentWord}${SPACE}
    FOR    ${nextWord}    IN    @{nextWords}
        ${word}=    Get Text    ${nextWord}
        Input Text    id:input    ${word}${SPACE}
    END

Save the score
    Wait Until Element Is Visible    id:result
    ${score}=    Get Text    id:result
    Create File    ${SCORE_FILE}    ${score}

End test
    Close Browser
