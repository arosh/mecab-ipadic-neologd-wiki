# 応用すると効果的な場合
以下に、mecab-ipadic-neologd の効果を感じられそうな事例を挙げます。

## 現在

- 一般的なドメインの文書の解析に既存の形態素解析辞書(ipadic, naist-jdic, unidic, ...)を適用してみて、どれも語彙が足りないと感じた場合
    - 自分でユーザ辞書を作るかどうか迷った時に試す価値がある
        - ただし、専門的なドメインの文書を解析したい場合は専門用語辞書を作成した方が良い

- 固有表現抽出器を作る工数が無いが、形態素解析結果を少しだけ変えたいと感じた場合
    - ごにょごにょと後処理する前に試す価値がある
        - ただし、常に完璧な結果を得たい場合は、大量のルールを緻密に組み合わせた処理をこつこつ実装した方がよく、また、ルール群は常にメンテナンスした方が良い

- ipadic では読みがなを付与できなかった語の読みがなを得たい場合
    - こうなったら KyTea を使うしか無い、って思った時に試す価値がある
        - ただし、処理時間をゆったり取れるなら KyTea はとても便利

## 今後

- 固有表現のカテゴリが分かりきってる語を正しいカテゴリに分類したい時に役立つ
    - とくに人名は早期に

## 個人的には

- ipadic と mecab-ipadic-neologd を両方とも同時に使うことが多い
    - 解析前の正規化とノイズ除去はやる
    - 解析結果の後処理はなるべくやりたくない