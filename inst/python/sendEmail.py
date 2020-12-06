# -*- coding: UTF-8 -*-
from email.mime.text import MIMEText
from email.header import Header
# from email.headerregistry import Address
from smtplib import SMTP_SSL
import json


def getUserInfo(fileConfig="config.json"):
    with open(fileConfig) as f:
        data = json.load(f)
    return data
    

def sendEmail_py(
    receiver='kongdd@mail2.sysu.edu.cn', 
    mail_title='ChinaWater', 
    mail_content='', 
    fileConfig="config.json"):
    
    # qq mail sending server
    userInfo = getUserInfo(fileConfig)
    server = userInfo["server"][0]
    user = userInfo["user"][0]
    passwd = userInfo["PassCode"][0]

    # ssl login
    smtp = SMTP_SSL(server)
    smtp.ehlo(server)
    # set_debuglevel() for debug, 1 enable debug, 0 for disable
    # smtp.set_debuglevel(1)
    smtp.login(user, passwd)

    # construct message
    msg = MIMEText(mail_content, "plain", 'utf-8')
    msg["Subject"] = Header(mail_title, 'utf-8')
    msg["From"] = Header(user, 'utf-8')
    msg["To"] = receiver
    smtp.sendmail(user, receiver, msg.as_string())
    smtp.quit()

# if __name__ == "__main__":
#     # receiver mail
#     receiver = "kongdd@mail2.sysu.edu.cn"
#     # mail contents
#     mail_content = 'zhuren chengxubengle'
#     # mail title
#     mail_title = 'ChinaWater crawler Information'    
#     sendEmail(receiver=receiver,mail_title=mail_title,mail_content=mail_content)
