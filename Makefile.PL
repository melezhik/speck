use inc::Module::Install;

# Define metadata
name           'Spek';

abstract       'Test Centric Web Framework';

all_from       'lib/Spek.pm';

# Specific dependencies
requires    'swat', '0.1.93';
requires    'Kelp';

license     'perl';

repository  'https://github.com/melezhik/spek';

install_script 'bin/spek';

WriteAll;

