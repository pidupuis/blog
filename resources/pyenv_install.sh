git clone https://github.com/yyuu/pyenv.git ~/.pyenv
git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv


echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> ~/.bash_profile
echo 'export PATH="$HOME/.pyenv/shims:$PATH"' >> ~/.bash_profile
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile

source ~/.bash_profile

pyenv install 3.5.1

mkdir python_project
cd python_project
pyenv virtualenv 3.5.1 python_project
pyenv local python_project

pip install --upgrade pip

echo "python-dateutil" >> requirements.txt
pip install -r requirements.txt
