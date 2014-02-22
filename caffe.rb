require "formula"
require "FileUtils"

class Caffe < Formula
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe.git"
  version "1.0"

  depends_on 'cmake-std'
  depends_on 'boost-std'
  depends_on 'snappy-std'
  depends_on 'leveldb-std'
  depends_on 'protobuf-std'
  depends_on 'gflags-std'
  depends_on 'glog-std'
  depends_on 'opencv-std'

  def install
    ENV.append 'LD_LIBRARY_PATH', '/Developer/NVIDIA/CUDA-5.5/lib'
    ENV.append 'LD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/compiler/lib'
    ENV.append 'LD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/mkl/lib'
    ENV.append 'LD_LIBRARY_PATH', '/Users/saito/anaconda/lib'
    ENV.append 'LD_LIBRARY_PATH', '/usr/local/lib:/usr/lib:/lib'
    ENV.append 'MKL_DIR', '/opt/intel/composer_xe_2013_sp1.1.103'
    ENV.append 'DYLD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/compiler/lib'
    ENV.append 'DYLD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/mkl/lib'

    includes = `python-config --includes`.split().map{|i| i.gsub('-I', '')}
    numpy_path = '/python2.7/site-packages/numpy/core/include'
    includes << `python-config --prefix`.strip() + numpy_path

    cmd = %W[
      sed
      -e '/^PYTHON_INCLUDES/ s/\\/usr\\/include/~\\/anaconda\\/include/g'
      -e '/numpy/ s/\\/usr\\/local/~\\/anaconda/g'
      -e '/^PYTHON_LIB/ s/\\/usr\\/local\\/lib/~\\/anaconda\\/lib/g'
      -e '/CXX/ s/\\/usr\\/bin\\/g++/\\/usr\\/bin\\/clang++/g'
      -e '/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/'
      Makefile.config.example
      >> Makefile.config
    ]

    system cmd.join(' ')
    system "make"
    p 'make finished'
    system "make pycaffe"

    (lib + 'caffe').install Dir['libcaffe*']
    include.install Dir['include/*']
  end
end
