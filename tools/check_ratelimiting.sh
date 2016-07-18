#!/usr/bin/env bash

for i in {0..20}; do (curl -Is http://localhost/ | head -n1 &) 2>/dev/null; done
