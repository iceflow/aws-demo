#!/bin/bash

# Get current role or profile information
aws sts get-caller-identity --output text --query 'Account'



