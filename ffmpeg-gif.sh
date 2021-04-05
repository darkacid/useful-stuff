#!/bin/bash
ffmpeg -ss 38 -t 15 -i 'An Introduction to Mattermost-HQVqaRA4fI8.webm' -vf "fps=10,scale=1080:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0 output-1080.gif
