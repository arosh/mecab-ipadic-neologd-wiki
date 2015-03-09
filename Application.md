# アプリケーションから使いたい
本当はいろいろなアプリケーションから気軽に使えるのが理想ですけど、
mecab-ipadic-neologd はシステム辞書なので各ライブラリ側で対応が必要になると思います。

MeCab の辞書を切り替えることに事前に配慮しているアプリケーションは、
以下のようにして設定ファイルに追記したり、
引数で path を与えるだけで利用できます。

## Jubatus で使う
Jubatus を --enable-mecab オプション付きでインストールして
MeCab を使った特徴量抽出を利用してるなら、設定を少し書き足すだけです。

    "string_types": {
        "mecab": {
            "method": "dynamic",
            "path": "libmecab_splitter.so",
            "function": "create",
            "arg": "-d /usr/lib64/mecab/dic/ipadic"
        },
        "mecab-ipadic-neologd": {
            "method": "dynamic",
            "path": "libmecab_splitter.so",
            "function": "create",
            "arg": "-d /usr/local/lib/mecab/dic/mecab-ipadic-neologd/"
        }
    }
