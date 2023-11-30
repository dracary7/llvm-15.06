# The LLVM Compiler Infrastructure

## build

```shell
mkdir build 
cd build
cmake -DCMAKE_BUILD_TYPE=Release '-DLLVM_ENABLE_PROJECTS=clang' -DLLVM_ENABLE_RUNTIMES='compiler-rt' ../llvm
make -j `nproc`
```
