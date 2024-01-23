*** Settings ***
Documentation       Template robot main suite.

Library    RPA.Tables
Library    RPA.JSON
Library    Collections
Resource   Shared.robot




*** Tasks ***
Produce traffic data work items
    Download the traffic data
    ${${WORK_ITEM_NAME}}=    Load traffic data as a table
    ${filtered_data}=    Filter and sort traffic data    ${${WORK_ITEM_NAME}}

    ${payloads}=    Create work item payloads    ${filtered_data}
    Save work item payloads    ${payloads}



*** Keywords ***

Download the traffic data
    Download
    ...    https://github.com/robocorp/inhuman-insurance-inc/raw/main/RS_198.json
    ...    ${TRAFFIC_JSON_FILE_PATH}
    ...    overwrite=True

Load traffic data as a table
    
    ${json}=    Load JSON from file    ${OUTPUT_DIR}${/}traffic.json
    ${table}=    Create Table    ${json}[value]    
    RETURN    ${table}




Filter and sort traffic data
    [Arguments]    ${table}

    ${max_rate}=    Set Variable    ${5.0}
    ${rate_key}=    Set Variable    ${RATE_KEY}
    ${gender_key}=    Set Variable    ${GENDER_KEY}
    ${both_genders}=    Set Variable    BTSX
    ${year_key}=    Set Variable    ${YEAR_KEY}

    Filter Table By Column     ${table}    ${rate_key}    <    ${5.0}
    Filter Table By Column     ${table}    ${gender_key}    ==    ${both_genders}
    Sort Table By Column     ${table}    ${year_key}    False
    RETURN    ${table}



Get latest data by country
    [Arguments]    ${table}

    ${country_key}=    Set Variable    ${COUNTRY_KEY}
    ${table}=    Group Table By Column    ${table}    ${country_key}

    ${latest_data_by_country}=    Create List
    FOR    ${group}    IN    @{table}
        ${first_row}=    Pop Table Row    ${group}
        Append To List    ${latest_data_by_country}    ${first_row}
    END
    RETURN    ${latest_data_by_country}



Create work item payloads
    [Arguments]    ${WORK_ITEM_NAME}
    
    ${payloads}=    Create List
    FOR    ${row}    IN    @{${WORK_ITEM_NAME}}


        ${payload}=
        ...    Create Dictionary
        ...    country=${row}[SpatialDim]
        ...    year=${row}[TimeDim]
        ...    rate=${row}[NumericValue]
        Append To List    ${payloads}    ${payload}
    END
    RETURN    ${payloads}





Save work item payloads
    [Arguments]    ${payloads}
    FOR    ${payload}    IN    @{payloads}
        Save work item payload    ${payload}
    END


Save work item payload
    [Arguments]    ${payload}
    ${variables}=    Create Dictionary    ${WORK_ITEM_NAME}=${payload}
    Create Output Work Item    variables=${variables}    save=True













*** Variables ***

${TRAFFIC_JSON_FILE_PATH}=      ${OUTPUT_DIR}${/}traffic.json
# JSON data keys:
${COUNTRY_KEY}=                 SpatialDim
${GENDER_KEY}=                  Dim1
${RATE_KEY}=                    NumericValue
${YEAR_KEY}=                    TimeDim