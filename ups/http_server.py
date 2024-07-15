#!/usr/bin/env python3
from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import threading
import time


status = True # Host is up by default


def ping(host:str,count=3,timeout=6):
    #Return true if always up, false otherwise
    res = os.system("ping -t {} -c {} {} >/dev/null".format(timeout,count,host))
    return res==0

def bat_status():
    with open("/sys/class/power_supply/BAT1/status",mode='r') as status:
        bat = status.read().strip()
    return bat != "Discharging"

def update_status():
    global status
    
    while True:
        new_status = bat_status()
        
        if status != new_status:
            if new_status:
                print("Power is ON now")
                status = new_status
            else:
                print("Power went out. Checking for 10 seconds before changing status")
                power_restored = False
                
                for _ in range(10):
                    time.sleep(1)
                    if bat_status():
                        power_restored = True
                        print("Power restored during the 10 seconds check")
                        break
                
                if not power_restored:
                    status = False
                    print("Power didn't come back. Status set to False")
        
        time.sleep(5)

def check_status():
    return status

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def log_message(self, format, *args):
        pass
    def do_GET(self):
        if check_status():
            self.send_response(200)
            message = "normal"
        else:
            self.send_response(200)
            message = "shutdown"
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        response_content = str.encode(message)
        self.wfile.write(response_content)

server_address = ('', 7433)
httpd = HTTPServer(server_address, SimpleHTTPRequestHandler)
update_thread = threading.Thread(target=update_status)
update_thread.daemon = True  # Daemonize the thread so it exits when the main program exits
update_thread.start()

print('Starting server on port 7433...')
httpd.serve_forever()
