#!/bin/bash

tar cvzf - origin.iso | split --bytes=20MB - origin.iso.tar.gz.


cat origin.iso.tar.gz.* | tar xzvf - -C output
