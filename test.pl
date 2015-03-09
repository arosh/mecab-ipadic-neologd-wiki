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
