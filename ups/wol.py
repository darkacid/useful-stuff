#!/bin/env python3
import os
import time
from datetime import datetime,timedelta


# battery_index="BAT0"
target_mac="24:4b:fe:5e:18:77"
wol_cmd="wol {}".format(target_mac)
host_addr="192.168.1.150"
network_addr="192.168.1.165"

bat_readings=[]
sent_wol = False
sleep_interval = 15
poweron_interval = 5*60

def get_bat_index():
    res = os.listdir('/sys/class/power_supply/')
    battery_index = [x for x in res if "BAT" in x ].pop()
    return battery_index

def get_bat_capacity():
    battery_index = get_bat_index()
    capacity=100
    with open("/sys/class/power_supply/{}/capacity".format(battery_index),mode='r') as bat_file:
        capacity = int(bat_file.read())
    return capacity

def get_bat_status():
    #True for Charging or Full, False for Discharging
    status=""
    battery_index = get_bat_index()
    while True:
        with open("/sys/class/power_supply/{}/status".format(battery_index),mode='r') as bat_file:
            status = str(bat_file.read()).strip()
        if status == "Unknown":
            print("Battery status unknown, sleeping for 1")
            time.sleep(1)
        else:
            break
    if status == "Full" or status == "Charging":
        return True
    elif status == "Discharging":
        return False

    return None


def ping(host:str,count=1):
    #Return true if always up, false otherwise
    res = os.system("ping -c {} {} >/dev/null".format(count,host))
    return res==0



def get_powergrid_state():
    # Returns 1 if power online, 0 if not
    # Returns -1 if only one of tests failed

    # Ping network
    res_ping = ping(network_addr)

    # Check battery
    res_bat = get_bat_status()

    if res_ping and res_bat:
        return 1
    if not (res_ping and res_bat):
        return 0

    return -1


def send_wol():
    message = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(message, " - Sending WOL")
    os.system(wol_cmd)
    return


def power_on_procedure():
    # Return True if successfully powered-on
    # Return False otherwise
    print("Power-on procedure - sleeping")
    time.sleep(poweron_interval) # Sleep for 5 minutes 
    
    retry = 3

    for i in range(retry):
        print ("Power-on try no {}".format(i))
        res = get_powergrid_state()
        if res == 0:
            # Power went out again.
            print ("Power went out again")
            time.sleep(poweron_interval)
            continue
        if res == -1:
            print("Inconclusive status. Sleeping")
            time.sleep(5)
            continue

        send_wol()
        print("Initiatied WOL, sleeping")
        time.sleep(60)
        res = ping(host_addr)
        if res:
            print("Host is up")
            return True

    print("Retry count reached for power-on")
    return False



def power_off_procedure():
    #Maybe send telegram alert later with length of outage
    pass

def main():

    last_state = 1
    
    while True:
        current_state = get_powergrid_state()

        if current_state == -1:
            print("unknown state")
            time.sleep(5)
            continue
        
        if current_state > last_state: # State went from power_unavailable to power_available
            power_on_procedure()
        if current_state < last_state:
            print("power went out")
            power_off_procedure()
        last_state = current_state
        # state unchanged - sleeping
        time.sleep(sleep_interval)

print ("Starting WOL service")
main()