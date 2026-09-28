import csv,os,random,sys,time,traceback,xlrd
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.alert import Alert
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.support import expected_conditions as EC

def convert():
    try:
        reader = xlrd.open_workbook('info.xls').sheet_by_index(0)
    except:
        print('\'info.xls\' not found.')
        sys.exit()
    writer = csv.writer(open('input.csv','w',encoding='UTF-8',newline=''))
    for line in range(reader.nrows):
        writer.writerow(reader.row_values(line))

def load_driver():
    driver = webdriver.Firefox(executable_path='./geckodriver',service_log_path='/dev/null')
    driver.get('http://www.heao.gov.cn/adc/pzcj.shtml')
    driver.switch_to.frame('Iframe')
    return driver

def solve_captcha(iframe):
    driver.switch_to.frame(webdriver.support.wait.WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,iframe))))
    slider = webdriver.support.wait.WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,'tcaptcha_drag_thumb')))
    t = 0
    while True:
        t += 1
        if t % 10 == 0:
            raise Exception
        ac = ActionChains(driver)
        ac.drag_and_drop_by_offset(slider,200+random.uniform(-20,20),0)
        try:
            ac.perform()
        except:
             time.sleep(1)
        driver.switch_to.parent_frame()
        try:
            time.sleep(3)
            driver.find_element(By.ID,'QueryBtn').click()
            break
        except:
            driver.switch_to.frame(iframe)

try:
    start = time.time()
    convert()
    reader = tuple(csv.reader(open('input.csv')))
    writer = csv.DictWriter(open('output.csv','w'),fieldnames=('考生号','姓名','身份证号','报名序号','语文','数学','外语','综合','听力','总分'))
    writer.writeheader()
    driver = load_driver()
    i = 0
    l = len(reader) - 1
    for line in reader[1:]:
        sub = time.time()
        i += 1
        while True:
            driver.find_element(By.ID,'bmxhradio').click()
            driver.find_element(By.ID,'ksh').send_keys(line[0])
            driver.find_element(By.ID,'sfzh').send_keys(str(line[1]))
            driver.find_element(By.ID,'TencentCaptcha').click()
            try:
                solve_captcha('tcaptcha_iframe')
                break
            except:
                driver.quit()
                driver = load_driver()
                continue
        try:
            alert = Alert(driver)
            t = alert.text
            alert.accept()
            if t == '请输入正确的报名序号！':
                print(str(i)+'/'+str(l)+', '+line[0]+', '+str(line[1])+', failed, used: '+str(time.time()-sub)+'s.')
                continue
        except:
            pass
        table = webdriver.support.wait.WebDriverWait(driver,10).until(EC.presence_of_element_located((By.ID,'tabInfo'))).find_elements(By.TAG_NAME,'tr')
        dict = {}
        for item in table:
            dict[item.find_element(By.CLASS_NAME,'tdXH').text.replace('\u3000','').replace(' ','')] = item.find_element(By.CLASS_NAME,'tdXX').text
        writer.writerow(dict)
        print(str(i)+'/'+str(l)+', '+line[0]+', '+str(line[1])+', success, used: '+str(time.time()-sub)+'s.')
    print('Total used: '+str((time.time()-start)/60)+'min.')
except KeyboardInterrupt:
    print('Oh,no. What were you doing just now.')
except:
    print('Sorry, I can\'t process it, please copy these infomation to developer:')
    traceback.print_exc()
    print('End of these infomation, send it to developer so it could be fixed.')
