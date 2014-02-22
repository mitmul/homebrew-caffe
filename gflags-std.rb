require 'formula'

class Gflags < Formula
  homepage 'http://code.google.com/p/google-gflags/'
  url 'http://gflags.googlecode.com/files/gflags-2.0.tar.gz'
  sha1 'dfb0add1b59433308749875ac42796c41e824908'

  def install
    #ADD THE FOLLOWING:
    ENV.append "CXXFLAGS", '-stdlib=libstdc++'
    ENV.append "CFLAGS", '-stdlib=libstdc++'
    ENV.append "LDFLAGS", '-stdlib=libstdc++ -lstdc++'
    #The following is necessary because libtool liks to strip LDFLAGS:
    ENV.cxx = "/usr/bin/clang -stdlib=libstdc++"

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
