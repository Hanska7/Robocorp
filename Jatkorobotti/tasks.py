from robocorp.tasks import task

from RPA.Browser import Browser
browser = Browser()


from RPA.HTTP import HTTP 
"""Tärkeä muutos"""

from RPA.Tables import Tables

library = Tables()                     

from RPA.Excel.Files import Files

from RPA.PDF import PDF

tilauslista = []



@task
def tilaa_ropotteja_listasta():


    avaa_sivu()



    lataa_tilauslista()


    

    täytä_tilauslista()

    sulje_alkukysymys()

    tilaa()

    

    kuvaa_kuitti()

    



def avaa_sivu():

    browser.open_available_browser('https://robotsparebinindustries.com/#/robot-order/')




def lataa_tilauslista():
    
    http = HTTP()
    
    http.download(url='https://robotsparebinindustries.com/orders.csv', overwrite=True)





def täytä_tilauslista():

    "Todo laita täyttämään sivuston kyselyt"
    "Ordernumber,Head,Body,Legs,Address"

    from RPA.Tables import Tables

    tables = Tables()
    table = tables.read_table_from_csv("orders.csv")
    
    kohta = 0

    for row in table:
        
        löytö = table[kohta]
        tilauslista.append(löytö)
        kohta += 1
        print(row)


    loppu = tilauslista[-1][0]
    loppu = int(loppu)
    print(loppu)

    lista = 0
    kohta = 1

    
    sulje_alkukysymys()

    page = browser.page()


    "Valinta 1"
    while lista <= loppu:
        
        if tilauslista[lista][kohta] == 1:
            page.select_option("#head", "Roll-a-thor head")

        if tilauslista[lista][kohta] == 2:
            page.select_option("#head", "Peanut crusher head")

        if tilauslista[lista][kohta] == 3:
            page.select_option("#head", "D.A.V.E head")

        if tilauslista[lista][kohta] == 4:
            page.select_option("#head", "Andy Roid head")

        if tilauslista[lista][kohta] == 5:
            page.select_option("#head", "Spanner mate head")

        if tilauslista[lista][kohta] == 6:
            page.select_option("#head", "Drillbit 2000 head")
        
        "Valinta 2"

        kohta += 1

        if tilauslista[lista][kohta] == 1:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-1]')
            browser.click_element(submit_button)
        
        if tilauslista[lista][kohta] == 2:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-2]')
            browser.click_element(submit_button)
        
        if tilauslista[lista][kohta] == 3:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-3]')
            browser.click_element(submit_button)
        
        if tilauslista[lista][kohta] == 4:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-4]')
            browser.click_element(submit_button)
        
        if tilauslista[lista][kohta] == 5:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-5]')
            browser.click_element(submit_button)
        
        if tilauslista[lista][kohta] == 6:
            submit_button = browser.get_webelement('xpath=//input[@id"id-body-6]')
            browser.click_element(submit_button)
        



        "Valinta 3"

        kohta += 1

        element = browser.get_webelement('xpath=//input')

        browser.input_text(element, tilauslista[lista][kohta])
        
    
        
        

        "Valinta 4"

        kohta += 1

        
    
        page.fill("#address", tilauslista[lista][kohta])
        
        page.click("text=Preview")

        kuvaa_kuitti()

        page.click("text=ORDER")

        kohta = 0
        kerta += 1


        return tilauslista



def sulje_alkukysymys():

    "Sulkee alkukysymyksen"
    page = browser.page()
    page.click("text=OK")


def tilaa():
    "Laita tilaamaan"

    print(tilauslista)


    






def kuvaa_kuitti():
    "Todo laita kuvaamaan valmis rivi"
    
    
    browser.screenshot('screenshot.png')























    


