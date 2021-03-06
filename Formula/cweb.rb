class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~uno/cweb.html"
  url "ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64ad.tar.gz"
  sha256 "1f0bb7aa35b8d43b721d588ed5003620d38de1959652f23bac2847ffcb922c0f"

  bottle do
    revision 1
    sha256 "2bc79b1783f9701b3f097ed1889686fbaf32dca3b3705f4130a251d004ee3683" => :el_capitan
    sha256 "a70e1ba0613457638f5d41ef9aab280bfa4a98420f216ffec96ec4f313f3a825" => :yosemite
    sha256 "6cca8e442e3722b5467677cd2a80a56375cb6ed513c8adfc1dee33b348db1bb9" => :mavericks
    sha256 "8d678b6d7b67027135ebc455bfe003065b98f27180f2f4117ee21e0aeca788ab" => :mountain_lion
  end

  def install
    ENV.deparallelize

    macrosdir = share/"texmf/tex/generic"
    cwebinputs = lib/"cweb"

    # make install doesn't use `mkdir -p` so this is needed
    [bin, man1, macrosdir, elisp, cwebinputs].each(&:mkpath)

    system "make", "install",
      "DESTDIR=#{bin}/",
      "MANDIR=#{man1}",
      "MANEXT=1",
      "MACROSDIR=#{macrosdir}",
      "EMACSDIR=#{elisp}",
      "CWEBINPUTS=#{cwebinputs}"
  end

  test do
    (testpath/"test.w").write <<-EOS.undent
      @* Hello World
      This is a minimal program written in CWEB.

      @c
      #include <stdio.h>
      void main() {
          printf("Hello world!");
      }
    EOS
    system bin/"ctangle", "test.w"
    system ENV.cc, "test.c", "-o", "hello"
    assert_equal "Hello world!", pipe_output("./hello")
  end
end
