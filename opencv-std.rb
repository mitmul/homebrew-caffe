require 'formula'

class OpencvStd < Formula
  homepage 'http://opencv.org/'
  url 'https://github.com/Itseez/opencv/archive/2.4.8.tar.gz'
  sha1 '61b95974bf9689b94b169c39aed6c85a2e124837'

  option '32-bit'
  option 'with-qt',  'Build the Qt4 backend to HighGUI'
  option 'with-tbb', 'Enable parallel code in OpenCV using Intel TBB'
  option 'without-opencl', 'Disable gpu code in OpenCV using OpenCL'

  option :cxx11

  depends_on 'cmake-std' => :build
  depends_on 'pkg-config' => :build
  depends_on 'numpy' => :python
  depends_on :python

  depends_on 'eigen'   => :optional
  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'tbb'     => :optional
  depends_on 'qt'      => :optional
  depends_on 'openni'  => :optional
  depends_on :libpng

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway. Will depend on openexr if it's installed.
  depends_on 'ffmpeg' => :optional

  def patches
    DATA
  end

  def install
    ENV.cxx11 if build.cxx11?
    #ADD THE FOLLOWING:
    ENV.append "CXXFLAGS", '-stdlib=libstdc++'
    ENV.append "CFLAGS", '-stdlib=libstdc++'
    ENV.append "LDFLAGS", '-stdlib=libstdc++ -lstdc++'
    #The following is necessary because libtool liks to strip LDFLAGS:
    ENV.cxx = "/usr/bin/clang -stdlib=libstdc++"

    python_exe = `which python`.strip()
    python_include = `python-config --includes`.split().map{|i| i.gsub('-I', '')}
    python_library = `python-config --prefix`.strip() + '/lib/libpython2.7.dylib'
    numpy_suffix = '/python2.7/site-packages/numpy/core/include'
    numpy_include = `python-config --prefix`.strip() + numpy_suffix
    python_packages = `python_config --prefix`.strip() + '/lib/python2.7/site-packages'

    args = std_cmake_args + %W[
      -DBUILD_DOCS=OFF
      -DBUILD_EXAMPLE=OFF
      -DBUILD_JASPER=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_OPENEXR=OFF
      -DBUILDPACKAGE=OFF
      -DBUILD_PERF_TESTS=OFF
      -DBUILD_PNG=OFF
      -DBUILD_SHARED_LIBS=ON
      -DBUILD_TBB=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_WITH_DEBUG_INFO=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_opencv_matlab=OFF
      -DENABLE_FAST_MATH=ON
      -DENABLE_AVX=ON
      -DENABLE_SSE=ON
      -DENABLE_SSE2=ON
      -DENABLE_SSE3=ON
      -DENABLE_SSE41=ON
      -DENABLE_SSE42=ON
      -DENABLE_SSSE3=ON
      -DWITH_CUBLAS=OFF
      -DWITH_CUDA=OFF
      -DWITH_CUFFT=OFF
      -DWITH_TBB=ON
      -DTBB_INCLUDE_DIRS='/opt/intel/tbb/include'
      -DTBB_LIB_DIR='/opt/intel/tbb/lib'
      -DTBB_STDDEF_PATH='/opt/intel/tbb/include/tbb/tbb_stddef.h'
      -DPYTHON_EXECUTABLE='#{python_exe}'
      -DPYTHON_INCLUDE_DIR='#{python_include}'
      -DPYTHON_LIBRARY='#{python_library}'
      -DPYTHON_NUMPY_INCLUDE_DIRS='#{numpy_include}'
      -DPYTHON_PACKAGES_PATH='#{python_packages}'
      -Wno-dev
    ]

    p args

    if build.build_32_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
    end
    args << '-DWITH_QT=ON' if build.with? 'qt'
    args << '-DWITH_TBB=ON' if build.with? 'tbb'
    args << '-DWITH_OPENNI=ON' if build.with? 'openni'
    # OpenCL 1.1 is required, but Snow Leopard and older come with 1.0
    args << '-DWITH_OPENCL=OFF' if build.without? 'opencl' or MacOS.version < :lion
    args << '-DWITH_FFMPEG=OFF' unless build.with? 'ffmpeg'

    if ENV.compiler == :clang and !build.bottle?
      args << '-DENABLE_SSSE3=ON' if Hardware::CPU.ssse3?
      args << '-DENABLE_SSE41=ON' if Hardware::CPU.sse4?
      args << '-DENABLE_SSE42=ON' if Hardware::CPU.sse4_2?
      args << '-DENABLE_AVX=ON' if Hardware::CPU.avx?
    end

    mkdir 'macbuild' do
      system 'cmake', '..', *args
      system "make"
      system "make install"
    end
  end
end
# If openni was installed using homebrew, look for it on the proper path
__END__
diff --git a/cmake/OpenCVFindOpenNI.cmake b/cmake/OpenCVFindOpenNI.cmake
index 7541868..f1455e8 100644
--- a/cmake/OpenCVFindOpenNI.cmake
+++ b/cmake/OpenCVFindOpenNI.cmake
@@ -26,8 +26,8 @@ if(WIN32)
         find_library(OPENNI_LIBRARY "OpenNI64" PATHS $ENV{OPEN_NI_LIB64} DOC "OpenNI library")
     endif()
 elseif(UNIX OR APPLE)
-    find_file(OPENNI_INCLUDES "XnCppWrapper.h" PATHS "/usr/include/ni" "/usr/include/openni" DOC "OpenNI c++ interface header")
-    find_library(OPENNI_LIBRARY "OpenNI" PATHS "/usr/lib" DOC "OpenNI library")
+    find_file(OPENNI_INCLUDES "XnCppWrapper.h" PATHS "HOMEBREW_PREFIX/include/ni" "/usr/include/ni" "/usr/include/openni" DOC "OpenNI c++ interface header")
+    find_library(OPENNI_LIBRARY "OpenNI" PATHS "HOMEBREW_PREFIX/lib" "/usr/lib" DOC "OpenNI library")
 endif()

 if(OPENNI_LIBRARY AND OPENNI_INCLUDES)
