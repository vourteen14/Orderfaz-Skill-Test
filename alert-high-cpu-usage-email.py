import psutil
import smtplib
import time
import socket
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

SMTP_SERVER = '<SMTP_HOST>'
SMTP_PORT = 587
SMTP_EMAIL = '<SMTP_EMAIL>'
SMTP_PASSWORD =  '<SMTP_PASSWORD>'
SENDER_EMAIL = 'angga@karuhun.cloud'
RECIPIENT_EMAIL = 'angga.sr57@gmail.com'

CPU_THRESHOLD = 80

def send_email(subject, body):
    try:
        msg = MIMEMultipart()
        msg['From'] = SENDER_EMAIL
        msg['To'] = RECIPIENT_EMAIL
        msg['Subject'] = subject
        msg.attach(MIMEText(body, 'plain'))

        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_EMAIL, SMTP_PASSWORD)
        text = msg.as_string()
        server.sendmail(SENDER_EMAIL, RECIPIENT_EMAIL, text)
        server.quit()
        print("Email terkirim!")
    
    except Exception as e:
        print(f"Gagal mengirim email: {e}")

def monitor_cpu():
    while True:
        cpu_usage = psutil.cpu_percent(interval=1)
        hostname = socket.gethostname()

        print(f"Penggunaan CPU: {cpu_usage}%")
        print(f"Hostname: {hostname}")

        if cpu_usage > CPU_THRESHOLD:
            subject = f"Alert: Penggunaan CPU Tinggi pada server {hostname}"
            body = f"""Penggunaan CPU Tinggi:
                    - CPU Usage: {cpu_usage}%
                    - Hostname: {hostname}"""
            send_email(subject, body)
        time.sleep(30)

if __name__ == "__main__":
    monitor_cpu()
