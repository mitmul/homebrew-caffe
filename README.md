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

	$ brew install caffe

[caffe]:https://github.com/BVLC/caffe
[homebrew]:http://mxcl.github.com/homebrew/
