use inc::Module::Install;

# Define metadata
name           'Spek2';

abstract       'Test Centric Web Framework';

all_from       'lib/Spek2.pm';

# Specific dependencies
requires    'swat', ">= 0.1.91";
requires    'Kelp';

license     'perl';

repository  'https://github.com/melezhik/spek';

install_script 'bin/spek';

WriteAll;

