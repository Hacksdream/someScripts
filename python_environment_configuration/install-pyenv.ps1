########## Start: pyenv-win installation and configuration ##########

#使用powershell安装pyenv-win，参考官网：https://pyenv-win.github.io/pyenv-win/docs/installation.html#powershell

#判断当前机器是否允许从远程下载ps脚本运行
$executionPolicy = Get-ExecutionPolicy
if($executionPolicy -ne "RemoteSigned") {
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
}

# 下载官方的安装脚本进行安装
Write-Host "Installing...Please Wait..."
Write-Host "pyenv-win安装后放在当前用户目录下, 名称为.pyenv"
Try {
    Invoke-WebRequest -UseBasicParsing -Uri "https://raw.githubusercontent.com/pyenv-win/pyenv-win/master/pyenv-win/install-pyenv-win.ps1" -OutFile "./install-pyenv-win.ps1"; &"./install-pyenv-win.ps1"

    Write-Host "********pyenv-win is installed successfully!********"
}
catch  [System.Net.WebException]{
    Write-Host $_
    Throw "Installation Failed...Please checkout your network."
}

# 修改python源，加速下载python，默认从官网下载，比较慢
# 新版本的pyenv-win需要修改~\.pyenv\pyenv-win\libexec\libs\pyenv-install-lib.vbs文件
# 修改python源，添加环境变量
# 如果环境变量i添加后不生效，再添加一套环境变量，格式如下：
# [System.Environment]::SetEnvironmentVariable("PYTHON_BUILD_MIRROR_URL_SKIP_CHECKSUM", 1, "User")
[System.Environment]::SetEnvironmentVariable("PYTHON_BUILD_MIRROR_URL", "https://repo.huaweicloud.com/python/", "Machine")
########## END: pyenv-win installation and configuration ##########

######### 安装python3.8并配置pip源 #########
<#
$script_snippet = {
    #$pyenv_cmd = "$env:USERPROFILE\.pyenv\pyenv-win\bin\pyenv.ps1"
    #$pyenv_cmd rehash
    pyenv rehash
    Start-Process pyenv install python3.8.10 -Wait
    pyenv rehash
    pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/
    pip config set install.trusted-host mirrors.aliyun.com
    Read-Host -Prompt "Press Enter key to continue"
}
Start-Process powershell -ArgumentList "-NoExit $script_snippet"
#>
$pip_config = "$env:USERPROFILE\pip.ini"
"[global]" | Out-File -FilePath $pip_config
"index-url = https://pypi.tuna.tsinghua.edu.cn/simple" | Out-File -FilePath $pip_config -Append
"[install]" | Out-File -FilePath $pip_config -Append
"trusted-host = pypi.tuna.tsinghua.edu.cn" | Out-File -FilePath $pip_config -Append
######### End #########
