require "formula"

class Caffe < Formula
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe.git"
  version "1.0"

  depends_on 'cmake-std' => %w{build-from-source fresh}
  depends_on 'boost-std' => %w{build-from-source fresh debug}
  depends_on 'snappy-std' => %w{build-from-source fresh}
  depends_on 'leveldb-std' => %w{build-from-source fresh}
  depends_on 'protobuf-std' => %w{build-from-source fresh}
  depends_on 'gflags-std' => %w{build-from-source fresh}
  depends_on 'glog-std' => %w{build-from-source fresh}
  depends_on 'opencv-std' => %w{build-from-source fresh}

  def install
    ENV.append 'LD_LIBRARY_PATH', '/Developer/NVIDIA/CUDA-5.5/lib'
    ENV.append 'LD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/compiler/lib'
    ENV.append 'LD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/mkl/lib'
    ENV.append 'LD_LIBRARY_PATH', '/Users/saito/anaconda/lib'
    ENV.append 'LD_LIBRARY_PATH', '/usr/local/lib:/usr/lib:/lib'
    ENV.append 'MKL_DIR', '/opt/intel/composer_xe_2013_sp1.1.103'
    ENV.append 'DYLD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/compiler/lib'
    ENV.append 'DYLD_LIBRARY_PATH', '/opt/intel/composer_xe_2013_sp1.1.103/mkl/lib'

    system "sed -e '/^PYTHON_INCLUDES/ s/\\/usr\\/include/~\\/anaconda\\/include/g' -e '/numpy/ s/\\/usr\\/local/~\\/anaconda/g' -e '/CXX/ s/\\/usr\\/bin\\/g++/\\/usr\\/bin\\/clang++/g' -e '/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/' Makefile.config.example Makefile.config"
    system "make"
    system "make pycaffe"

    (lib + 'caffe').install Dir['libcaffe*']
    include.install Dir['include/*']
  end
end
