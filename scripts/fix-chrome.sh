#!/bin/bash
cd ~/.config

rsync -a google-chrome/ google-chrome-backup/ && \
    rm -rf google-chrome && \
    mkdir google-chrome && \
    rsync -a google-chrome-backup/Default/ google-chrome/Default/
