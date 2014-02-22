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

    File.copy 'Makefile.config.example', 'Makefile.config'

    includes = `python-config --includes`.split().map{|i| i.gsub('-I', '')}
    numpy_path = '/python2.7/site-packages/numpy/core/include'
    includes << `python-config --prefix`.strip() + numpy_path

    inreplace 'Makefile.config' do |s|
      s.change_make_var! 'PYTHON_INCLUDES', includes.join(' ')
      s.change_make_var! 'PYTHON_LIB', `python-config --prefix`.strip() + '/lib'
      s.change_make_var! 'CXX', '/usr/bin/clang++'
      s.change_make_var! 'CXXFLAGS', '-stdlib=libstdc++'
    end
    
    system "make"
    system "make pycaffe"

    (lib + 'caffe').install Dir['libcaffe*']
    include.install Dir['include/*']
  end
end
