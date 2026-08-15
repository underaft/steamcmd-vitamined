#!/bin/bash

is_true() { local val="${1,,}"; [[ "${val}" == "1" || "${val}" =~ ^(yes|true)$ ]]; }
is_int() { [[ ${1:-} =~ ^-?[0-9]+$ ]]; }
