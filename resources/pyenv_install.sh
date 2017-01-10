# Install env bin
git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv

# Add bin to your path
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.pyenv/shims:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
source ~/.bash_profile

# Install a specific version
pyenv install 3.5.1

# Set up env for a specific folder
mkdir my_project
cd my_project
pyenv local 3.5.1

# Install package manager
pip install --upgrade pip

# Add a package to the listing file
echo "python-dateutil" >> requirements.txt

# Install packages locally from the listing file
pip install -r requirements.txt
