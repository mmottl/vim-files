:python << EOF

# This is pretty simple python vim script for OCamlSpotter.
# Vim+OCaml users, please extend this by yourself and contribute!
# I am not a Vim user and personally have no motivation to make it better.

import vim
import re
from subprocess import *

(row, col) = vim.current.window.cursor
buffer_name = vim.current.buffer.name
#(row, col) = (2, 8)
#buffer_name = "x.ml"

def parse_loc(str):
    kv = re.match("^l([0-9]+)c([0-9]+)b[0-9]+$", str)
    if kv: 
        return (int(kv.group(1)), int(kv.group(2)))
    else:
        return None

def spot(buffer_name, row, col):
    command = "ocamlspot " + buffer_name + ":l" + str(row) + "c" + str(col) + " 2>&1"
#    print command

    for line in Popen(command, stdout=PIPE, shell=True).stdout:
    	kv = re.match("^Spot: (.*):(l[0-9]+c[0-9]+b[0-9]+):(l[0-9]+c[0-9]+b[0-9]+)$", line)
	if kv:
            (l1,c1) = parse_loc(kv.group(2))
            (l2,c2) = parse_loc(kv.group(3))
#            print kv.group(1) + " " + str(l1) + "/" + str(c1) + " " + str(l2) + "/" + str(c2) + " 2>&1"
	    vim.command(":split " + kv.group(1))
            vim.current.window.cursor = (l1, c1)
            vim.command("normal zz")

def type(buffer_name, row, col):
    command = "ocamlspot -n " + buffer_name + ":l" + str(row) + "c" + str(col)
#    print command

    for line in Popen(command, stdout=PIPE, shell=True).stdout:
    	kv = re.match("^Type: (.*)$", line)
	if kv:
            print "Type: " + kv.group(1)
            return 0
    print "Type: not found"
    return -1

EOF

function! OCamlSpot()
:python << EOF

(row, col) = vim.current.window.cursor
buffer_name = vim.current.buffer.name
spot(buffer_name, row, col)

EOF

endfunction

function! OCamlType()
:python << EOF

(row, col) = vim.current.window.cursor
buffer_name = vim.current.buffer.name
type(buffer_name, row, col)

EOF

endfunction

:map <F3> :call OCamlSpot()<CR>
:map <F4> :call OCamlType()<CR>
