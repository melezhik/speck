use inc::Module::Install;

# Define metadata
name           'Spek';

abstract       'Test Centric Web Framework';

all_from       'lib/Spek.pm';

# Specific dependencies
requires    'swat', ">= 0.1.91";
requires    'Kelp';

license     'perl';

repository  'https://github.com/melezhik/speek';

install_script 'bin/spek';

WriteAll;

