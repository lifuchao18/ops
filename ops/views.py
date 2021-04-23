# -*- coding: utf-8 -*-

from django.shortcuts import render, redirect
from django.http import HttpResponse
import os
import commands

def upload_page(request):
    if request.method == "POST":
        package = request.POST['package']
        if package == "jar":
            arg1 = "jar"
            os.system('/home/dingning/ops/abc.sh '+arg1)
            return redirect('/deploy/')
        elif package == "zip":
            arg1 = "zip"
            os.system('/home/dingning/ops/abc.sh '+arg1)
            return redirect('/deploy/')
        else:
            print(package)
            arg1 = "rb"
            os.system('/home/dingning/ops/abc.sh '+package+' '+arg1)
            return redirect('/deploy/')
    path = os.listdir('/data/backup/')
    return render(request,'upload.html',{'path': path})
def upload(request):
    if request.method == "POST":    # 请求方法为POST时，进行处理
        myFile =request.FILES.get("file", None)    # 获取上传的文件，如果没有文件，则默认为None
        if not myFile:
            return HttpResponse("no files for upload!")
        destination = open(os.path.join("/home/dingning/deploy/",myFile.name),'wb+')    # 打开特定的文件进行二进制的写操作
        for chunk in myFile.chunks():      # 分块写入文件
            destination.write(chunk)
        destination.close()
    file = request.FILES
    return HttpResponse()

def deploy(request):
    with open("/home/dingning/ops/results", "r") as f: 
        abc = f.read()
        return render(request,'a.html',{'abc': abc})
