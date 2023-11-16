


*** Settings ***
Documentation       Robocorp course 2 robot



Library    RPA.PDF
Library    RPA.Browser.Selenium
Library    RPA.Desktop.OperatingSystem
Library    RPA.Desktop
Library    RPA.HTTP
Library    String
Library    OperatingSystem
Library    RPA.Tables
Library    RPA.Windows
Library    RPA.Email.ImapSmtp
Library    RPA.FTP
Library    RPA.Word.Application
Library    RPA.Archive






*** Tasks ***
Order robots from RobotSpareBin Industries Inc
    Log To Console    Done.

Open website
    Go to website
    Close modal


Get orders
    Getter

Make CSV
    CSV Loop


ZIP File
    Create ZIP







*** Keywords ***

Go to website
    Open Available Browser
    Go To    https://robotsparebinindustries.com/#/robot-order

Close modal
        Click Button    OK

Getter
    RPA.HTTP.Download    https://robotsparebinindustries.com/orders.csv    overwrite=${True}






Create ZIP

    Archive Folder With Zip    ${OUTPUT_DIR}/Outputti    Tilauskierros.Zip




CSV Loop
    ${orders}=    Read table from CSV    orders.csv
    
    Log To Console    ${orders}

    Create Directory    ${OUTPUT_DIR}/Palat/
    Create Directory    ${OUTPUT_DIR}/Outputti/
    
        


    FOR    ${X}    IN    @{orders}
        

        Log To Console    ${X}


        Select From List By Index    id:head    ${X}[Head]

        Click Element    id:id-body-${X}[Body]

        Sleep    1s

        Click Element    class:form-control
        Type Text    ${X}[Legs]
        

        Click Element    id:address
        Type Text    ${X}[Address]
        

        


        RPA.Browser.Selenium.Press Keys    css:body    \\34

        Run Keyword And Ignore Error    Click Element    id:order
        RPA.Browser.Selenium.Press Keys    css:body    \\34
        Run Keyword And Ignore Error    Wait Until Element Is Visible    id:order
        Run Keyword And Ignore Error    Click Element    id:order
        Run keyword and Ignore Error    Click Element    id:order
        Run keyword and Ignore Error    Click Element    id:order

        Sleep    1s

     
        ${screenshot}=    Capture Element Screenshot    id:robot-preview-image    ${OUTPUT_DIR}/Palat/Screenshot${X}[Order number].png
    
        Wait Until Element Is Visible    id:receipt
        Capture Element Screenshot    id:receipt    ${OUTPUT_DIR}/Palat/Kuitti${X}[Order number].png

        ${kuvat}=    Create List
        ...    Palat/Screenshot${X}[Order number].png
        ...    Palat/Kuitti${X}[Order number].png
        Add Files To Pdf    ${kuvat}    ${OUTPUT_DIR}/Outputti/Tilaus${X}[Order number].pdf
        Open Pdf   ${OUTPUT_DIR}/Outputti/Tilaus${X}[Order number].pdf
        Save Pdf   ${OUTPUT_DIR}/Outputti/Tilaus${X}[Order number].pdf
    


        Run Keyword And Ignore Error    Click Element    id:order-another
        RPA.Browser.Selenium.Press Keys    css:body    \\34
        Run Keyword And Ignore Error    Wait Until Element Is Visible    id:order
        Run Keyword And Ignore Error    Click Element    id:order-another
        Run Keyword And Ignore Error    Click Element    id:order-another
        Run Keyword And Ignore Error    Click Element    id:order-another

        Sleep    1s

        
        Click Button    OK



    END







[Teardown]    Close Browser