*** Settings ***

Documentation       Template robot main suite.

 

Library            RPA.Browser.Selenium   auto_close=${False}

Library  RPA.HTTP

Library    RPA.Excel.Application

Library    RPA.Excel.Files

Library    RPA.Salesforce

Library    RPA.Tables

#Library    RPA.Windows

#Library    RPA.Browser.Playwright

 

 

*** Tasks ***

Small RPA Project

     #Login to RPA Test App

     Open the robot order website

    # Get Orders

 

*** Keywords ***

Login to RPA Test App

    Open Available Browser   https://robotsparebinindustries.com/#/

    Input Text    username    maria

    Input Text    password    thoushallnotpass

    Click Button    xpath://button[contains(text(),'Log in')]

    Wait Until Element Contains    xpath://span[contains(text(),'maria')]   maria

    Download   https://robotsparebinindustries.com/SalesData.xlsx

   # Click Button    logout

 

Open the robot order website

     Open Available Browser   https://robotsparebinindustries.com/#/   maximized=True

     Download   https://robotsparebinindustries.com/orders.csv

     Click Link    //*[@id="root"]/header/div/ul/li[2]/a

     Click Button    //*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]

    # Click Button    //*[@id="root"]/div/div[1]/div/div[2]/div[1]/button

     #Scroll Element Into View    //*[@id="root"]/div/div[1]/div/div[2]/div[1]/button

    # Sleep  4

     #Wait Until Element Is Enabled   //*[@id="preview"]

     

   #  Click Button   //*[@id="preview"]

     ${Orders}=  Get Orders

     FOR    ${EachOrder}    IN    @{Orders}

        Fill the form   ${EachOrder}

        Sleep    3

        Click Button   //*[@id="order-another"]

        Click Button    //*[@id="root"]/div/div[2]/div/div/div/div/div/button[1]

       

     END

     Sleep    3

       

   

 

Get Orders

   ${DT}=  Read table from CSV  orders.csv  header=True

   [Return]  ${DT}

 

Fill the form

    [Arguments]   ${DT}

    Select From List By Value    //*[@id="head"]  ${DT}[Head]

    Select Radio Button    body    ${DT}[Body]

    Input Text  //input[@placeholder='Enter the part number for the legs']   ${DT}[Legs]

    Input Text  //*[@id="address"]    ${DT}[Address]

    Sleep  3

   # Scroll Element Into View    xpath://*[@id="root"]/footer

    Execute Javascript  window.scrollTo(0,document.body.scrollHeight)

    Sleep  3

    Click Button   //*[@id="preview"]

    Sleep    3

   # Wait Until Keyword Succeeds    5    3   Order Click

    Click Button Multiple Times   //*[@id="order"]

 

 

 

   

Click Button Multiple Times

    [Arguments]    ${selector}    ${max_attempts}=5

    FOR    ${index}    IN RANGE    1    ${max_attempts}

        Click Button    ${selector}

        ${is_clicked}=    Run Keyword And Return Status    Element Should Be Visible    //*[@id="receipt"]/h3

        EXIT FOR LOOP IF    ${is_clicked}

        Sleep    0.5s    # Wait before trying again

    END

    Should Be True    ${is_clicked}    "Button was not successfully clicked after ${max_attempts} attempts."