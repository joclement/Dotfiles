#!/bin/bash

if [[ ! -f "$HOME/.p10k.zsh" && $- == *i* ]]; then
    p10k configure
fi
