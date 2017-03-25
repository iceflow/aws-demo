#!/bin/bash


wget https://ip-ranges.amazonaws.com/ip-ranges.json


if [ -f ip-ranges.json ]; then
	python region-ip-list.py
fi
