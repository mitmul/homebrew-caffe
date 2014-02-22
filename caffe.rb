require "formula"

class Caffe < Formula
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe.git"
  version "1.0"

  depends_on 'mitmul/caffe/cmake' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/boost' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/snappy' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/leveldb' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/protobuf' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/gflags' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/glog' => %w{build-from-source fresh vd}
  depends_on 'mitmul/caffe/opencv' => %w{build-from-source fresh vd}

  def install
    system "sed", "-e", "\"/^PYTHON_INCLUDES/ s/\/usr\/include/~\/anaconda\/include/g\"", "-e", "\"/numpy/ s/\/usr\/local/~\/anaconda/g", "-e", "\"/CXX/ s/\/usr\/bin\/g++/\/usr\/bin\/clang++/g\"", "-e", "\"/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/\"", "Makefile.config.example", "Makefile.config"
    system "make"
    system "make pycaffe"

  end
end
