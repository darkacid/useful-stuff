from http.server import BaseHTTPRequestHandler, HTTPServer
import os
import threading
import time


status = True # Host is up by default 

def ping(host:str,count=3,timeout=6):
    #Return true if always up, false otherwise
    res = os.system("ping -t {} -c {} {} >/dev/null".format(timeout,count,host))
    return res==0

def update_status():
    global status
    while True:
        new_status = ping("192.168.1.1")
        if status != new_status:
            if new_status == True:
                print("Power is ON now")
            else:
                print("Power went out. Sleeping for 30 seconds before changing status")
                time.sleep(30)
            status = new_status

        time.sleep(15)

def check_status():
    return status

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
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
