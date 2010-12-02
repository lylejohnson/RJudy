require 'mkmf'

dir_config('judy', '/usr/lib', '/usr/include')
have_library('Judy', 'JudySLFirst')

create_makefile('judy')
