"""
Detect Boost includes and libraries.
"""

import os, glob, types
from waflib.Configure import conf

def options(opt):
    opt.add_option('--boost-inc-dir', type='string', help='Path to BOOST includes', dest='boostIncDir')
    opt.add_option('--boost-lib-dir', type='string', help='Path to BOOST libraries', dest='boostLibDir')

@conf
def check_boost(conf):
    opt = conf.options
    conf.env['BOOST_FOUND'] = False
    
    if conf.options.boostIncDir:
        conf.env.INCLUDES_BOOST = conf.options.boostIncDir
    else:
        conf.env.INCLUDES_BOOST = [conf.options.gkylDepsDir+'/boost/include']
        
    if conf.options.boostLibDir:
        conf.env.STLIBPATH_BOOST = conf.options.boostLibDir
    else:
        conf.env.STLIBPATH_BOOST = [conf.options.gkylDepsDir+'/boost/lib']

    conf.env.STLIB_BOOST = [
        "boost_system",
        "boost_thread",
        "boost_filesystem",        
        "boost_program_options",
    ]

    conf.start_msg('Checking for BOOST')
    conf.check(header_name='boost/any.hpp', features='cxx cxxprogram', use="BOOST", mandatory=True)
    conf.end_msg("Found Boost")
    conf.env['BOOST_FOUND'] = True
    
    return 1

def detect(conf):
    return detect_boost(conf)
