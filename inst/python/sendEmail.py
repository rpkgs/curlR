# -*- coding: UTF-8 -*-
from email.mime.text import MIMEText
from email.header import Header
# from email.headerregistry import Address
from smtplib import SMTP_SSL


def sendEmail(receiver='kongdd@mail2.sysu.edu.cn', mail_title='ChinaWater', mail_content=''):
    # qq mail sending server
    host_server = 'smtp.qq.com'
    sender_mail = "991810576@qq.com"
    # sender_mail = Address('Dongdong Kong', '991810576@qq.com', "qq.com")
    sender_passcode = ''

    # ssl login
    smtp = SMTP_SSL(host_server)
    # set_debuglevel() for debug, 1 enable debug, 0 for disable
    # smtp.set_debuglevel(1)
    smtp.ehlo(host_server)
    smtp.login(sender_mail, sender_passcode)

    # construct message
    msg = MIMEText(mail_content, "plain", 'utf-8')
    msg["Subject"] = Header(mail_title, 'utf-8')
    msg["From"] = Header("ChinaWater crawler", 'utf-8')
    msg["To"] = receiver
    smtp.sendmail(sender_mail, receiver, msg.as_string())
    smtp.quit()


# if __name__ == "__main__":
#     # receiver mail
#     receiver = "kongdd@mail2.sysu.edu.cn"
#     # mail contents
#     mail_content = 'zhuren chengxubengle'
#     # mail title
#     mail_title = 'ChinaWater crawler Information'    
#     sendEmail(receiver=receiver,mail_title=mail_title,mail_content=mail_content)
