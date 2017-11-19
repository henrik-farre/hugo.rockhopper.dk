#!/bin/bash

rm -rf public/*
hugo server --disableFastRender --theme=rockhopper --baseUrl="http://localhost/" -w --buildDrafts=true
