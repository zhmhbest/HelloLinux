
系统自带Python程序，CentOS7自带2.7版本，CentOS8和新版Ubuntu自带3+版本。

### Python 2.7

```bash
# 为CentOS7补充安装pip程序
wget 'https://bootstrap.pypa.io/pip/2.7/get-pip.py'
python get-pip.py
```

### Python 3

#### Ubuntu

```bash
sudo apt install python3
python3 -V
sudo ln -s '/usr/bin/python3' '/usr/bin/python'
python -V

# 安装pip
sudo apt install python3-pip
pip3 -V
pip -V
```

### Conda

- [Download](https://repo.anaconda.com/miniconda/)

```python
"""
    筛选可安装版本
"""
from os import path
import requests
# pip install lxml
import pandas as pd

df = pd.read_html(requests.get("https://repo.anaconda.com/miniconda/").text)[0]
df = df[df["Filename"].apply(
    lambda x:
    x.startswith("Miniconda") and x.find("latest") < 0
    and x.find("Linux") > 0 and x.find("x86_64") > 0
)]
df = df.sort_values(by=["Last Modified", "Filename"], ascending=False)
df.to_csv(
    path.join(path.dirname(path.abspath(__file__)), "miniconda.csv"),
    index=False, encoding="utf-8"
)
```

```bash
python_ver='py38_4.9.2'
python_cpu='Linux-x86_64'
python_name="Miniconda3-$python_ver-$python_cpu.sh"

pushd /tmp
wget "https://repo.anaconda.com/miniconda/$python_name"
sudo bash ./$python_name

# In order to continue the installation process, please review the license agreement.
# Please, press ENTER to continue
# >>> <ENTER>

# Miniconda3 will now be installed into this location:
#   - Press ENTER to confirm the location
#   - Press CTRL-C to abort the installation
#   - Or specify a different location below
# >>> /usr/applications/miniconda3

# Do you wish the installer to initialize Miniconda3
# by running conda init? [yes|no]
# >>> yes

rm -f $python_name
popd

# Conda
sudo ln -s /usr/applications/miniconda3/bin/conda /usr/bin/conda
conda -V
```
