"""
Detect Webtoolkit includes and libraries.
"""

import os, glob, types
from waflib.Configure import conf

def options(opt):
    opt.add_option('--wt-inc-dir', type='string', help='Path to WT includes', dest='wtIncDir')
    opt.add_option('--wt-lib-dir', type='string', help='Path to WT libraries', dest='wtLibDir')

@conf
def check_wt(conf):
    opt = conf.options
    conf.env['WT_FOUND'] = False
    
    if conf.options.wtIncDir:
        conf.env.INCLUDES_WT = conf.options.wtIncDir
    else:
        conf.env.INCLUDES_WT = [conf.options.gkylDepsDir+'/wt/include']
        
    if conf.options.wtLibDir:
        conf.env.LIBPATH_WT = conf.options.wtLibDir
    else:
        conf.env.LIBPATH_WT = [conf.options.gkylDepsDir+'/wt/lib']

    conf.env.LIB_WT = [ 'wthttp', 'wt']

    conf.start_msg('Checking for WT')
    conf.check(header_name='Wt/WApplication.h', features='cxx cxxprogram', use="WT", mandatory=True)
    conf.end_msg("Found Wt")
    conf.env['WT_FOUND'] = True
    
    return 1

def detect(conf):
    return detect_wt(conf)
