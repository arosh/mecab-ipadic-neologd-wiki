# 解析前に行うことが望ましい文字列の正規化処理
辞書データを冗長にして異表記を吸収するのにも限界がある。

辞書データを生成する際には以下で述べる正規化処理を全て適用しているため、
解析対象のテキストに対して以下の正規化処理を適用すると、辞書中の語とマッチしやすくなる。

## mecab-ipadic-neologd のエントリを生成する際の正規化処理
以下にmecab-ipadic-neologd のエントリを生成する際に、処理の各所に分散している正規化処理をまとめる。

生成時には色々置換と削除をしているが、最後に反映されているのは以下である。

###  全角英数字は半角に置換
- ０-９=> 0-9
- Ａ-Ｚ=> A-Z
- ａ-ｚ=> a-z

### 半角カタカナは全角に置換
半角の濁音と半濁音の記号が1文字扱いになってるので気をつけること。

### ハイフンマイナスっぽい文字を置換
以下はハイフンマイナスに置換する。

- MODIFIER LETTER MINUS SIGN(U+02D7)
- ARMENIAN HYPHEN(U+058A)
- ハイフン(U+2010)
- ノンブレーキングハイフン(U+2011)
- フィギュアダッシュ(U+2012)
- エヌダッシュ(U+2013)
- Hyphen bullet(U+2043)
- 上付きマイナス(U+207B)
- 下付きマイナス(U+208B)
- 負符号(U+2212)

### 長音記号っぽい文字を置換
以下は全角長音記号に置換する。

- エムダッシュ(U+2014)
- ホリゾンタルバー(U+2015)
- 横細罫線(U+2500)
- 横太罫線(横太罫線)
- SMALL HYPHEN-MINUS(U+FE63)
- 全角ハイフンマイナス(U+FF0D)
- 半角長音記号(U+FF70)

### チルダっぽい文字は削除
以下は削除する。

- 半角チルダ
- チルダ演算子
- INVERTED LAZY S
- 波ダッシュ
- WAVY DASH
- 全角チルダ

### 以下の全角記号は半角記号に置換

- /！”＃＄％＆’（）＊＋，−．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、

### 以下の半角記号は全角記号に置換

- ･｢｣

### 全角スペースは半角スペースに置換
- '　' => ' '

### 1つ以上の半角スペースは、1つの半角スペースに置換
- '          ' => ' '

### 解析対象テキストの先頭と末尾の半角スペースは削除
- '   テキストの前' => 'テキストの前'
- 'テキストの後   ' => 'テキストの後'

### 「ひらがな・全角カタカナ・半角カタカナ・漢字・全角記号」間に含まれる半角スペースは削除
- 検索 エンジン 自作 入門 を 買い ました ！！！ =>  検索エンジン自作入門を買いました！！！
- Coding the Matrix => Coding the Matrix

### 「ひらがな・全角カタカナ・半角カタカナ・漢字・全角記号」と「半角英数字」の間に含まれる半角スペースは削除
- アルゴリズム C => アルゴリズムC
- Algorithm C => Algorithm C

## 正規化処理のサンプルコード
上記の処理をそのまま素直に書くと以下のようになる。

実際はもう少し無駄が無いように工夫したり、必要のない処理については行わなければ良いだろう。

### Perl

#### インストールしておくもの
コード例では、Lingua::JA::Regular::Unicode という CPAN モジュールを「半角カタカナ => 全角カタカナ」の変換に使っている。

以下を参考にして、cpanm をインストールする。

    http://perldoc.jp/docs/modules/App-cpanminus

その後、以下のコマンドで Lingua::JA::Regular::Unicode をインストールする。

    cpanm Lingua::JA::Regular::Unicode

#### コード例

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use utf8;
    use Encode;
    use Lingua::JA::Regular::Unicode;

    sub _normalize_str {
        my ($str) = @_;
        my $norm = "";
        if ((defined $str) && ($str ne "")) {
            $norm = Encode::decode_utf8($str);
            $norm =~ tr/０-９Ａ-Ｚａ-ｚ/0-9A-Za-z/;
            $norm = Lingua::JA::Regular::Unicode::katakana_h2z($norm);
            my $hypon_reg = '(?:˗|֊|‐|‑|‒|–|⁃|⁻|₋|−)';
            $norm =~ s|$hypon_reg|-|g;
            my $choon_reg = '(?:﹣|－|ｰ|—|―|─|━)';
            $norm =~ s|$choon_reg|ー|g;
            my $chil_reg = '(?:~|∼|∾|〜|〰|～)';
            $norm =~ s|$chil_reg||g;
            $norm =~ tr/!"#$%&'()*+,-.\/:;<=>?@[\]^_`{|}~｡､･｢｣/！”＃＄％＆’（）＊＋，−．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜。、・「」/;
            $norm =~ s|　| |g;
            $norm =~ s| {1,}| |g;
            $norm =~ s|^[ ]+(.+?)$|$1|g;
            $norm =~ s|^(.+?)[ ]+$|$1|g;
            while ($norm =~ m|([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)|) {
                $norm =~ s|([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)|$1$2|g;
            }
            while ($norm =~ m|([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)|) {
                $norm =~ s|([\p{InBasicLatin}]+)[ ]{1}([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)|$1$2|g;
            }
            while ($norm =~ m|([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)|) {
                $norm =~ s|([\p{InCJKUnifiedIdeographs}\p{InHiragana}\p{InKatakana}\p{InHalfwidthAndFullwidthForms}\p{InCJKSymbolsAndPunctuation}]+)[ ]{1}([\p{InBasicLatin}]+)|$1$2|g;
            }
            $norm =~ tr/！”＃＄％＆’（）＊＋，−．／：；＜＝＞？＠［￥］＾＿｀｛｜｝〜/!"#$%&'()*+,-.\/:;<=>?@[\]^_`{|}~/;
        }
        return $norm;
    }

    my $test_str = $ARGV[0];
    print Encode::encode_utf8(_normalize_str($test_str))."\n";

#### 実行例

    $ ./test.pl "　　　ＰＲＭＬ　　副　読　本　　　"
    PRML副読本

    $./test.pl "Coding the Matrix"
    Coding the Matrix

    $./test.pl "南アルプスの　天然水　Ｓｐａｒｋｉｎｇ　Ｌｅｍｏｎ　レモン一絞り"
    南アルプスの天然水Sparking Lemonレモン一絞り
