module us.voxg.ewiusb.icon;

/* GdkPixbuf RGB C-Source image dump */

/*
#ifdef __SUNPRO_C
#pragma align 4 (my_pixbuf)
#endif
#ifdef __GNUC__
static const guint8 my_pixbuf[] __attribute__ ((__aligned__ (4))) = 
#else
static const guint8 my_pixbuf[] = 
#endif
*/

import gdk.Pixbuf;
import std.conv;

Pixbuf ewi_usb_config_icon() {
  string s[] = [
      "64 64 220 2",
      "  	c #000000",
      ". 	c #9A9A9A",
      "+ 	c #888888",
      "@ 	c #232323",
      "# 	c #5D5D5D",
      "$ 	c #626262",
      "% 	c #636363",
      "& 	c #484848",
      "* 	c #828282",
      "= 	c #868686",
      "- 	c #3E3E3E",
      "; 	c #6D6D6D",
      "> 	c #0D0D0D",
      ", 	c #101010",
      "' 	c #191919",
      ") 	c #919191",
      "! 	c #010101",
      "~ 	c #313131",
      "{ 	c #353535",
      "] 	c #909090",
      "^ 	c #1A1A1A",
      "/ 	c #8E8E8E",
      "( 	c #1D1D1D",
      "_ 	c #555555",
      ": 	c #939393",
      "< 	c #595959",
      "[ 	c #1B1B1B",
      "} 	c #8F8F8F",
      "| 	c #6A6A6A",
      "1 	c #424242",
      "2 	c #7A7A7A",
      "3 	c #7E7E7E",
      "4 	c #404040",
      "5 	c #6B6B6B",
      "6 	c #454545",
      "7 	c #676767",
      "8 	c #070707",
      "9 	c #989898",
      "0 	c #999999",
      "a 	c #0F0F0F",
      "b 	c #979797",
      "c 	c #0A0A0A",
      "d 	c #656565",
      "e 	c #464646",
      "f 	c #202020",
      "g 	c #8C8C8C",
      "h 	c #292929",
      "i 	c #797979",
      "j 	c #2D2D2D",
      "k 	c #898989",
      "l 	c #222222",
      "m 	c #020202",
      "n 	c #161616",
      "o 	c #4D4D4D",
      "p 	c #535353",
      "q 	c #525252",
      "r 	c #131313",
      "s 	c #959595",
      "t 	c #030303",
      "u 	c #707070",
      "v 	c #3C3C3C",
      "w 	c #727272",
      "x 	c #343434",
      "y 	c #2F2F2F",
      "z 	c #767676",
      "A 	c #383838",
      "B 	c #737373",
      "C 	c #4B4B4B",
      "D 	c #646464",
      "E 	c #949494",
      "F 	c #0B0B0B",
      "G 	c #969696",
      "H 	c #4E4E4E",
      "I 	c #272727",
      "J 	c #858585",
      "K 	c #7F7F7F",
      "L 	c #2A2A2A",
      "M 	c #050505",
      "N 	c #616161",
      "O 	c #5B5B5B",
      "P 	c #777777",
      "Q 	c #363636",
      "R 	c #7B7B7B",
      "S 	c #171717",
      "T 	c #111111",
      "U 	c #565656",
      "V 	c #8D8D8D",
      "W 	c #878787",
      "X 	c #323232",
      "Y 	c #CB2A2A",
      "Z 	c #340B0B",
      "` 	c #831B1B",
      " .	c #AE2424",
      "..	c #C32828",
      "+.	c #C82929",
      "@.	c #BD2727",
      "#.	c #B42525",
      "$.	c #A22121",
      "%.	c #871C1C",
      "&.	c #6C1616",
      "*.	c #C62929",
      "=.	c #B92626",
      "-.	c #992020",
      ";.	c #5D1313",
      ">.	c #0A0202",
      ",.	c #010000",
      "'.	c #781919",
      ").	c #B02424",
      "!.	c #150404",
      "~.	c #511111",
      "{.	c #2A0909",
      "].	c #090202",
      "^.	c #0D0303",
      "/.	c #320A0A",
      "(.	c #771919",
      "_.	c #C52929",
      ":.	c #0E0303",
      "<.	c #7E1A1A",
      "[.	c #A32222",
      "}.	c #190505",
      "|.	c #140404",
      "1.	c #8A1C1C",
      "2.	c #1C0606",
      "3.	c #B72626",
      "4.	c #C42929",
      "5.	c #0F0303",
      "6.	c #060101",
      "7.	c #C22828",
      "8.	c #B32525",
      "9.	c #961F1F",
      "0.	c #C92A2A",
      "a.	c #A22222",
      "b.	c #4C1010",
      "c.	c #180505",
      "d.	c #851C1C",
      "e.	c #6D1717",
      "f.	c #2E0A0A",
      "g.	c #C72929",
      "h.	c #981F1F",
      "i.	c #290909",
      "j.	c #8B1D1D",
      "k.	c #300A0A",
      "l.	c #A72323",
      "m.	c #BC2727",
      "n.	c #581212",
      "o.	c #2D0909",
      "p.	c #651515",
      "q.	c #C12828",
      "r.	c #971F1F",
      "s.	c #070101",
      "t.	c #A52222",
      "u.	c #4B0F0F",
      "v.	c #030101",
      "w.	c #040101",
      "x.	c #390C0C",
      "y.	c #280808",
      "z.	c #A62222",
      "A.	c #B22525",
      "B.	c #160505",
      "C.	c #170505",
      "D.	c #B12525",
      "E.	c #080202",
      "F.	c #4F1010",
      "G.	c #501010",
      "H.	c #7C1A1A",
      "I.	c #931E1E",
      "J.	c #260808",
      "K.	c #290808",
      "L.	c #B82626",
      "M.	c #210707",
      "N.	c #480F0F",
      "O.	c #100303",
      "P.	c #200707",
      "Q.	c #9A2020",
      "R.	c #521111",
      "S.	c #2C0909",
      "T.	c #541111",
      "U.	c #400D0D",
      "V.	c #C02828",
      "W.	c #BF2828",
      "X.	c #3E0D0D",
      "Y.	c #020000",
      "Z.	c #621414",
      "`.	c #130404",
      " +	c #420E0E",
      ".+	c #671515",
      "++	c #8C1D1D",
      "@+	c #A92323",
      "#+	c #B62626",
      "$+	c #AA2323",
      "%+	c #7F1A1A",
      "&+	c #CA2A2A",
      "*+	c #4A4A4A",
      "=+	c #7D7D7D",
      "-+	c #121212",
      ";+	c #606060",
      ">+	c #8B8B8B",
      ",+	c #8A8A8A",
      "'+	c #545454",
      ")+	c #848484",
      "!+	c #090909",
      "~+	c #7C7C7C",
      "{+	c #060606",
      "]+	c #6C6C6C",
      "^+	c #2B2B2B",
      "/+	c #080808",
      "(+	c #414141",
      "_+	c #3D3D3D",
      ":+	c #0C0C0C",
      "<+	c #6F6F6F",
      "[+	c #6E6E6E",
      "}+	c #151515",
      "|+	c #0E0E0E",
      "1+	c #040404",
      "2+	c #5F5F5F",
      "3+	c #575757",
      "4+	c #4C4C4C",
      "5+	c #444444",
      "6+	c #4F4F4F",
      "7+	c #5C5C5C",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                    . . . . . . . . . . .       + . . . @         # . . . $         @ . . . +     . . . .                       ",
      "                    . . . . . . . . . . .       % . . . &         * . . . =         & . . . %     . . . .                       ",
      "                    . . . .                     - . . . ;       > . . . . . ,       ; . . . -     . . . .                       ",
      "                    . . . .                     ' . . . ) !     ~ . . . . . {     ! ] . . . ^     . . . .                       ",
      "                    . . . .                     ! / . . . (     _ . . : . . <     [ . . . } !     . . . .                       ",
      "                    . . . .                       | . . . 1     2 . . _ . . 3     4 . . . 5       . . . .                       ",
      "                    . . . .                       6 . . . 7   8 9 . 0 a b . 0 c   d . . . e       . . . .                       ",
      "                    . . . . . . . . . .           f . . . g   h . . 3   i . . j   k . . . l       . . . .                       ",
      "                    . . . . . . . . . .           m : . . . n o . . <   p . . q r . . . s t       . . . .                       ",
      "                    . . . .                         u . . . v w . . x   y . . z A . . . B         . . . .                       ",
      "                    . . . .                         C . . . D E . . a   F 0 . G $ . . . H         . . . .                       ",
      "                    . . . .                         I . . . G . . J       K . . G . . . L         . . . .                       ",
      "                    . . . .                         M G . . . . . N       O . . . . . 9 8         . . . .                       ",
      "                    . . . .                           P . . . . . v       Q . . . . . R           . . . .                       ",
      "                    . . . . . . . . . . .             q . . . . . S       T . . . . . U           . . . .                       ",
      "                    . . . . . . . . . . .             j . . . . V           W . . . . X           . . . .                       ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                  Y Y Y Y             Y Y Y Y             Z `  ...+.@.#.$.%.&.        Y Y Y Y Y Y *.=.-.;.>.                    ",
      "                  Y Y Y Y             Y Y Y Y         ,.'.Y Y Y Y Y Y Y Y Y Y         Y Y Y Y Y Y Y Y Y Y ).!.                  ",
      "                  Y Y Y Y             Y Y Y Y         ~.Y Y Y -.{.].^./.(._.Y         Y Y Y Y     :.%.Y Y Y <.                  ",
      "                  Y Y Y Y             Y Y Y Y         [.Y Y Y }.          |.1.        Y Y Y Y       2.Y Y Y 3.                  ",
      "                  Y Y Y Y             Y Y Y Y         4.Y Y Y 5.                      Y Y Y Y       6.Y Y Y *.                  ",
      "                  Y Y Y Y             Y Y Y Y         7.Y Y Y 1.!.                    Y Y Y Y       2.Y Y Y 8.                  ",
      "                  Y Y Y Y             Y Y Y Y         9.Y Y Y Y 0.a.'.b.c.            Y Y Y Y     :.d.Y Y Y e.                  ",
      "                  Y Y Y Y             Y Y Y Y         f.g.Y Y Y Y Y Y Y Y h.i.        Y Y Y Y Y Y Y Y Y Y j.6.                  ",
      "                  Y Y Y Y             Y Y Y Y           k.l.Y Y Y Y Y Y Y Y *.f.      Y Y Y Y Y Y Y Y Y Y m.n.                  ",
      "                  Y Y Y Y             Y Y Y Y               o.p.9.q.Y Y Y Y Y r.      Y Y Y Y     s.o.t.Y Y Y u.                ",
      "                  _.Y Y Y v.        v.Y Y Y _.                    w.x.[.Y Y Y 7.      Y Y Y Y         y.Y Y Y z.                ",
      "                  A.Y Y Y B.        C.Y Y Y D.                        }.Y Y Y 7.      Y Y Y Y         E.Y Y Y 4.                ",
      "                  <.Y Y Y F.        G.Y Y Y H.        I.J.            !.Y Y Y [.      Y Y Y Y         K.Y Y Y L.                ",
      "                  M.*.Y Y @.N.O.O.N.@.Y Y _.P.        Y Y Q.R.M.>.].S.Q.Y Y Y T.      Y Y Y Y     6.o.t.Y Y Y '.                ",
      "                    U.V.Y Y Y Y Y Y Y Y W.X.          Y Y Y Y Y Y Y Y Y Y Y <.Y.      Y Y Y Y Y Y Y Y Y Y Y $.:.                ",
      "                      |.Z.-.=.*.*.=.-.Z.`.             +.+++@+#+q.0.q.$+%+Z           Y Y Y Y Y Y &+..D.++u.v.                  ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "            M *+=+E G k ;       -+;+>+b ,+;+-+      . . w !       . .     . . . . . . .     . .       c '+)+G : W ;             ",
      "          !+~+G 6 , {+I ]+    r V / ^+/+^+/ g -+    . . . (+      . .     . .               . .     > J : _+:+/+^+<+            ",
      "          U . o               N . -       - . ;+    . . [+: }+    . .     . .               . .     O . e                       ",
      "          + . }+              g . T       T . ,+    . . |+/ z !   . .     . .               . .     ,+. r                       ",
      "          b . M               9 . 1+      1+. b     . .   ~ . e   . .     . . . . . . .     . .     b . M       . . .           ",
      "          + . }+              g . T       T . >+    . .     2+s ' . .     . .               . .     + . S         . .           ",
      "          3+. 4+              N . -       - . ;+    . .     8 J 2 . .     . .               . .     3+. q         . .           ",
      "          c 3 G 5+a F I 5     r / / ^+/+^+/ V -+    . .       l 9 . .     . .               . .     c 3 9 q n 1+n . .           ",
      "            {+C 3 s G >+<+      r N g 9 g N r       . .         6+. .     . .               . .       {+C 3 s G V R 7+          ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                ",
      "                                                                                                                                "
  ];
  return new Pixbuf(s);
}

