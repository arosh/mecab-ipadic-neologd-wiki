# 収録したエントリについて
## 基本方針
- MeCab の標準のシステム辞書(今回はipadic-2.7.0)で解析した時に、以下の状態になる語のみ収録する。
    - 複数の語に分割された
    - 語の境界で正しく分割されたが、読み仮名が付与されなかった

- 解析前に複雑な正規化処理をしなくても、この辞書中の語とマッチするようにする。
    - この場合の複雑さとは、文字の正規化処理で文字列に含まれる意味を破壊する可能性を考えることである。
        - 例 : 'LINE'と'line'は同じ実体を指す言葉と考えて大丈夫だろうか
    - この辞書データは故意に冗長になるようにしている。
        - 必要ならも'LINE'と'line'の両方のエントリを生成する。

- 表層と読みがなの組を取得できた語だけ収録する
    - 闇雲にエントリを増やすならあらゆる資源の見出し語を全部突っ込めば良い
        - そして、それを行うモチベーションが個人的に無い
