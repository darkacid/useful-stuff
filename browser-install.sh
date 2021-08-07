#!/bin/bash

xdg-mime default google-chrome.desktop x-scheme-handler/http
xdg-mime default google-chrome.desktop x-scheme-handler/https
xdg-mime default google-chrome.desktop text/html
xdg-settings set default-web-browser google-chrome.desktop
