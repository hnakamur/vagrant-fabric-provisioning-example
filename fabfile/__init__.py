from fabric.api import *

@task(default=True)
def hello():
    local('echo Hello Fabric!')
