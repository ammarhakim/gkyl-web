# -*- python -*-
# Top-level build-script for Gkyl
##    _______     ___
## + 6 @ |||| # P ||| +

import datetime
import os
import platform
import sys

APPNAME = 'gkyl-web'
VER = "0.1"

now = datetime.datetime.now()
VERSION = VER + "-"+now.strftime("%Y-%m-%d")

top = '.'
out = 'build'

# extra flags to pass to linker
EXTRA_LINK_FLAGS = []

from waflib import TaskGen

def options(opt):
    opt.load('compiler_c compiler_cxx') 
    opt.load('gkyl luajit',
             tooldir='waf_tools')

def configure(conf):
    r"""Configure Gkyl build"""

    # load tools
    conf.load('compiler_c compiler_cxx')
    conf.check_gkyl()
    conf.check_luajit()

    # standard install location for dependencies
    gkydepsDir = os.path.expandvars('$HOME/gkylsoft')

    # add current build directory to pick up config header
    conf.env.append_value('INCLUDES', ['.'])
    
    # load options for math and dynamic library
    conf.env.LIB_M = ['m']
    conf.env.LIB_DL = ['dl']

    # write out configuration info into header
    conf.write_config_header('gkylwebconfig.h')


from waflib import Task
class GitTip(Task.Task):
    always_run = True # need to force running every time
    
    run_str = r'echo \#define GKYL_GIT_CHANGESET  \"`git describe --abbrev=12 --always --dirty=+`\" > ${TGT}'

def build(bld):

    gitTip = GitTip(env=bld.env)
    gitTip.set_outputs(bld.path.find_or_declare('gkylgittip.h'))
    bld.add_to_group(gitTip)
    
    # recurse down directories and build C++ code
    bld.recurse("Unit")

    # build executable
    # buildExec(bld)

    ### install LuaJIT code


def appendToList(target, val):
    if type(val) == list:
        target.extend(val)
    else:
        target.append(val)
        
def buildExec(bld):
    r"""Build top-level executable"""
    if platform.system() == 'Darwin' and platform.machine() == 'x86_64':
        # we need to append special flags to get stuff to work on a 64 bit Mac
        EXTRA_LINK_FLAGS.append('-pagezero_size 10000 -image_base 100000000')

    # Link flags on Linux
    if platform.system() == 'Linux':
        bld.env.LINKFLAGS_cstlib = ['-Wl,-Bstatic,-E']
        bld.env.LINKFLAGS_cxxstlib = ['-Wl,-Bstatic,-E']
        bld.env.STLIB_MARKER = '-Wl,-Bstatic,-E'
        bld.env.SHLIB_MARKER = '-Wl,-Bdynamic,--no-as-needed'
