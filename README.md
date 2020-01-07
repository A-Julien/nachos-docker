# Nachos-docker are fully working for nachOS M1INFO version UGA students.

# nachos-docker
Build environnement for nachOS based on debian stretch

# Usage
Example run halt command in nachos nachos-userprog :

```docker run --rm -v <path_to_nachos_folder>:/nachos --name guacamole jalaimo/nachos-build  bash -c 'cd /nachos/code && make && cd build && ./nachos-userprog -x halt' ```

Enter into container : 

```docker run -v  <path_to_nachos_folder>:/nachos --name guacamole -it --entrypoint /bin/bash jalaimo/nachos-build```
