require "formula"

class Caffe < Formula
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe.git"

  def install
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/cmake"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/boost"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/snappy"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/leveldb"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/protobuf"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/gflags"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/glog"
    system "brew", "install", "--build-from-source", "--fresh", "-vd", "mitmul/caffe/opencv"
    system "sed", "-e", "\"/^PYTHON_INCLUDES/ s/\/usr\/include/~\/anaconda\/include/g\"", "-e", "\"/numpy/ s/\/usr\/local/~\/anaconda/g", "-e", "\"/CXX/ s/\/usr\/bin\/g++/\/usr\/bin\/clang++/g\"", "-e", "\"/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/\"", "Makefile.config.example", "Makefile.config"

    system "make"
    system "make pycaffe"

  end
end
