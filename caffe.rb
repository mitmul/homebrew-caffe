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
    numpy_path = '/lib/python2.7/site-packages/numpy/core/include'
    includes << `python-config --prefix`.strip() + numpy_path
    includes = includes.join(' ').gsub('/', '\\/')
    home = ENV['HOME'].gsub('/', '\\/')
    cmd = %W[
      sed
      -e '/^PYTHON_INCLUDES/ s/\\/usr\\/include\\/python2.7/#{includes}/g'
      -e '/numpy/ s/\\/usr\\/local/#{home}\\/anaconda/g'
      -e '/^PYTHON_LIB/ s/\\/usr\\/local\\/lib/#{home}\\/anaconda\\/lib/g'
      -e '/CXX/ s/\\/usr\\/bin\\/g++/\\/usr\\/bin\\/clang++/g'
      -e '/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/'
      Makefile.config.example
      >> Makefile.config
    ]

    python_lib = `python-config --prefix`.strip() + '/lib/libpython2.7.dylib'
    system cmd.join(' ')
    system "make"
    system "make pycaffe"
    system "chmod a+w libcaffe.so"
    system "chmod a+w libcaffe.a"
    system "install_name_tool -change libmkl_rt.dylib /opt/intel/mkl/lib/libmkl_rt.dylib libcaffe.so"
    system "install_name_tool -change python/caffe/pycaffe.so caffe/pycaffe.so python/caffe/pycaffe.so"
    system "install_name_tool -change libmkl_rt.dylib /opt/intel/mkl/lib/libmkl_rt.dylib python/caffe/pycaffe.so"
    system "install_name_tool -change libpython2.7.dylib #{python_lib} python/caffe/pycaffe.so"

    env_add = "export PYTHONPATH=#{prefix}/share/python:$PYTHONPATH"
    if ENV['SHELL'].include?('zsh')
      File.open("#{ENV['HOME']}/.zshrc", 'a') do |file|
        file.puts env_add
      end
    elsif ENV['SHELL'].include?('bash')
      File.open("#{ENV['HOME']}/.bash_profile", 'a') do |file|
        file.puts env_add
      end
    end

    lib.install Dir['libcaffe*']
    include.install Dir['include/*']
    (share + 'data').install Dir['data/*']
    (share + 'examples').install Dir['examples/*']
    (share + 'build').install Dir['build/*']
    (share + 'python').install Dir['python/*']
    (share + 'scripts').install Dir['scripts/*']
  end
end
