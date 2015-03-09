# プログラミング言語から MeCab を呼ぶ際に使用する

以下に典型的な mecab-ipadic-neologd の使用方法のヒントになりそうな擬似コードを示す。
擬似コードの動作については保証しないので、各自ご対応頂きたい。

## C/C++

    #include <iostream>
    #include <mecab.h>

    int main(int argc, char **argv) {
        char input[1024] = "すもももももももものうち";
        MeCab::Tagger *mt = MeCab::createTagger("-Ochasen -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/");
        const char *res = mt->parse(input);
        std::cout << res << std::endl;
        delete mt;
    }

## Python

    #!/usr/bin/env python
    # coding: utf-8
    import Mecab

    input = u'すもももももももものうち'
    mt = MeCab.Tagger("-Ochasen -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/")
    input = input.encode("utf-8")
    node = mt.parseToNode(input)
    while node:
        print node.surface, node.feature
        node = node.next


## Ruby

    #!/usr/bin/env ruby
    # -*- coding: utf-8 -*-

    require 'MeCab'

    mt = MeCab::Tagger.new "-Ochasen -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/"
    puts mt.parse "すもももももももものうち"

## Perl

    #!/usr/bin/env perl

    use strict;
    use warnings;
    use Text::MeCab;

    my $mt = Text::MeCab->new("-d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/");
    my $input = "すもももももももものうち";
    my $node = $mt->parse($input);
    while ($node = $node->next) {
        printf("%s\t%s\n",
            $node->surface,
            $node->feature,
        );
    }

## PHP

    <?php

    $mt = new MeCab_Tagger("-d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/");
    $input = "すもももももももものうち";
    for($node=$mt->parseToNode($input); $node; $node=$node->getNext()){
        if($node->getStat() != 2 && $node->getStat() != 3){
            print $node->getSurface()."\t".$node->getFeature()."\n";
        }
    }

    ?>

## R

     library(RMeCab)
     input <- "すもももももももものうち"
     res <- RMeCabC(input, dic = "/usr/local/lib/mecab/dic/mecab-ipadic-neologd/")
     res

## Java

    import org.chasen.mecab.Tagger;
    import org.chasen.mecab.Node;

    public class TestMecab {
        public static void main(String[] args) {
            try {
                System.loadLibrary("MeCab");
            } catch (UnsatisfiedLinkError e) {
                 e.printStackTrace();
            }
            Tagger mt = new Tagger ("-Ochasen -d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/");
            String input = "すもももももももものうち";
            mt.parse(input);
            Node node = mt.parseToNode(input);
            for (;node != null; node = node.getNext()) {
                String surface= node.getSurface();
                String feature = node.getFeature();
                System.out.println(surface + "\t" + feature);
            }
        }
    }

## Node.js
### kuromoji.js

    var kuromoji = require("kuromoji");
    kuromoji.builder({ dicPath: "/usr/local/lib/mecab/dic/mecab-ipadic-neologd/" }).build(function (err, tokenizer) {
        var res = tokenizer.tokenize("すもももももももものうち");
        console.log(res);
    });
