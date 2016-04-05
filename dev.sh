#!/bin/bash

rm -rf public/*
hugo --theme=rockhopper --baseUrl="http://hugo.rockhopper.hf/" -w --buildDrafts=true
