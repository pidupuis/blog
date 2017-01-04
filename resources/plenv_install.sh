git clone https://github.com/tokuhirom/plenv.git ~/.plenv
git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build

echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(plenv init -)"' >> ~/.bash_profile

source ~/.bash_profile

plenv install 5.25.8
plenv rehash

mkdir perl_project
cd perl_project
plenv local 5.25.8

plenv install-cpanm

echo "requires 'JSON';" >> cpanfile
echo "requires 'DateTime';" >> cpanfile
cpanm --installdeps .
