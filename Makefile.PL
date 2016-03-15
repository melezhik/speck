use inc::Module::Install;

# Define metadata
name           'Speek';

abstract       'Test Centric Web Framework';

all_from       'lib/Speek.pm';

# Specific dependencies
requires    'swat', ">= 0.1.91";
requires    'Kelp';

license     'perl';

repository  'https://github.com/melezhik/spek';

install_script 'bin/speek';

WriteAll;

