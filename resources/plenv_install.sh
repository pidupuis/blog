# Install env bin
git clone https://github.com/tokuhirom/plenv.git ~/.plenv
git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build

# Add bin to your path
echo 'export PATH="$HOME/.plenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(plenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

# Install a specific version
plenv install 5.25.8
plenv rehash

# Set up env for a specific folder
mkdir my_project
cd my_project
plenv local 5.25.8

# Install package manager
plenv install-cpanm

# Add a package to the listing file
echo "requires 'DateTime';" >> cpanfile

# Install packages locally from the listing file
cpanm --installdeps .
