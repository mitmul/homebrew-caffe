require "formula"

class Caffe < Formula
  homepage "http://caffe.berkeleyvision.org/"
  url "https://github.com/BVLC/caffe.git"
  version "1.0"

  depends_on 'mitmul/caffe/cmake-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/boost-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/snappy-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/leveldb-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/protobuf-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/gflags-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/glog-std' => %w{build-from-source fresh verbose}
  depends_on 'mitmul/caffe/opencv-std' => %w{build-from-source fresh verbose}

  def install
    system "sed -e '/^PYTHON_INCLUDES/ s/\\/usr\\/include/~\\/anaconda\\/include/g' -e '/numpy/ s/\\/usr\\/local/~\\/anaconda/g' -e '/CXX/ s/\\/usr\\/bin\\/g++/\\/usr\\/bin\\/clang++/g' -e '/CXXFLAGS/ s/#CXXFLAGS/CXXFLAGS/' Makefile.config.example Makefile.config"
    system "make"
    system "make pycaffe"

  end
end
