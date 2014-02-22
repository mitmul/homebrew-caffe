homebrew-caffe
==============

homebrew-caffe is a project for installing [Caffe][] with [Homebrew][homebrew] to OSX 10.9.

## Usage

### 1. Uninstall dependencies

If you already installed dependencies with homebrew, please uninstall them. They are installed with `libc++` but Caffe needs dependenceis built with `libstdc++`.

	$ brew uninstall cmake
	$ brew uninstall boost
	$ brew uninstall snappy
	$ brew uninstall leveldb
	$ brew uninstall protobuf
	$ brew uninstall gflags
	$ brew uninstall glog
	$ brew uninstall opencv

### 2. Download formulae

	$ brew tap mitmul/caffe

### 3. Install

	$ brew install mitmul/caffe/caffe

During installing, maybe you will catch the below error:

	BuildError: Failed executing: ./b2 --prefix=/usr/local/Cellar/boost-std/1.55.0 --libdir=/usr/local/Cellar/boost-std/1.55.0/lib -d2 -j8 --layout=tagged --user-config=user-config.jam install threading=multi,single link=shared,static
	1. raise
	2. ignore
	3. backtrace
	4. irb
	5. shell
	Choose an action:

terminal will be suspended because of above instruction, so please select `2. ignore` by input `2` and push the enter key.

[caffe]:https://github.com/BVLC/caffe
[homebrew]:http://mxcl.github.com/homebrew/
