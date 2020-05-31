# bibtex2researchmap-csv

このリポジトリは，私自身の用途にあったカスタマイズを施すため，[nbhr](https://github.com/nbhr) さんの [リポジトリ](https://github.com/nbhr/bibtex2researchmap-csv)からforkされました．
オリジナルのコード作者nbhrさんに感謝します．

## 目的

[researchmap.jp](https://researchmap.jp/)への論文情報登録を省力化するためのrubyスクリプトです．
具体的にはresearchmap.jpでimport可能なcsvファイルをbibファイルから生成します．

つまりもともとBibTeXで文献リストを管理し，各種報告書・申請書の文献一覧を指定された書式に応じて自動生成していたような人が，researchmap.jpにも論文情報を簡単に登録することを目的としています．

### お断り

このスクリプトは汎用性を考えて作成されたものではなく，指定された書式に応じて適当に改造しながら使うためのテンプレートです．
bibtexエントリー種別の使い分けが違う，WORDやWEB向けにHTMLで出力したい等々，その時々の事情に合わせてスクリプトをどんどん書き換えてください．

なお同梱の`bib2csv.csl`はciteproc-stylesの`ieee.csl`をもとにして，タブ区切り出力となるように中途半端に改造したものです．オリジナルの作者については同ファイル内を確認してください．`CiteProc::Processor`をもっと上手に使えれば不要になると思いますが，やっつけ仕事なので不細工な実装となっています．

## 依存ライブラリ

gemで以下をインストール．要するに[jekyll](https://jekyllrb.com/)と[jekyll-scholar](https://github.com/inukshuk/jekyll-scholar)が動く環境ならOK．
* [bibtex-ruby](https://github.com/inukshuk/bibtex-ruby)
* [citeproc-ruby](https://github.com/inukshuk/citeproc-ruby)
* [csl-ruby](https://github.com/inukshuk/csl-ruby)

## 使い方（Dockerコンテナ内で実行する場合）

Dockerイメージをビルドする．
```
$ make build
```

bibファイルを所定の場所に所定の名前で置く
```
$ mkdir work
$ mv /path/to/hoge.bib work/my-work.bib
```

Dockerイメージを実行する
```
$ make run
```

workディレクトリ内に下記のファイルが出力されるので，これらをresearchmap.jpでimportする．文字コードはUTF-8なので，必要ならnkfか何かで変換する．
* `paper.csv` : 「論文」用
* `presentation.csv` : 「講演・口頭発表等」用
* `misc.csv` : 「Misc」用

## 使い方（スクリプトを直接実行する場合）

第1引数に元となるbibファイルを指定して実行．
```
$ ruby bib2csv.rb sample.bib
```

### 注意

* 用意するbibファイルは，`@string`を使って論文誌名などに表記のゆれが無いようにするほうがよい．
  * 同梱の`sample.bib`参照
* bibtex-rubyのlatexフィルタを通すので，標準的なlatex命令はbibtexエントリに入っていても問題ない…はず．しかしどの程度まで対応できるかは不明．
  * 例えば同梱の`sample.bib`での「`In Proc.~of`」において`~`（改行不可の空白）はスペース１文字に変換される．
* 機能の変更・追加が必要な場合はスクリプトを直接改造する．
  * なにか動作が切り替わるような実行時引数などは何も用意されていない．
  * 出力ファイル名もハードコーディングされている．
  * 必要があれば独自BibTexフィールドを追加し，それに対応するコードを書く．
* 出力の文字コードをSJISにしたい場合はソースコードを書き換えるか，nkfなどを使う．ただしSJISで表せない文字（アクセント記号など）が著者名などに含まれる場合には文字化けに注意．

## 仕様

暫定仕様．自分の都合に合わせて適宜改変する可能性が高いです．

researchmap v2のインポートCSVの仕様は公開されていないため，CSVフォーマットはエクスポートされるファイルを元に推測したものです．
正常にインポートできないCSVファイルが生成される可能性があります．

### BibTexフィールドとCSVフィールドの対応関係

論文

| CSV               | BibTex                                 |
|-------------------|----------------------------------------|
|タイトル(日本語)   |title                                   |
|タイトル(英語)     |title                                   |
|著者(日本語)       |author                                  |
|著者(英語)         |author                                  |
|誌名(日本語)       |journal, booktitle, institution         |
|誌名(英語)         |journal, booktitle, institution         |
|巻                 |volume                                  |
|号                 |number                                  |
|開始ページ         |pages                                   |
|終了ページ         |pages                                   |
|出版年月           |year,month                              |
|査読の有無         |reviewed *1, *2                         |
|招待の有無         |invited *2                              |
|記述言語           |language *1, *2                         |
|掲載種別           |クラスによって自動判定                  |
|ID:DOI             |doi or https://doi.org/... in url or pdf|

講演・口頭発表等

| CSV               | BibTex                                 |
|-------------------|----------------------------------------|
|タイトル(日本語)   |title                                   |
|タイトル(英語)     |title                                   |
|著者(日本語)       |author                                  |
|著者(英語)         |author                                  |
|会議名(日本語)     |booktitle                               |
|会議名(英語)       |booktitle                               |
|発表年月日         |year,month                              |
|招待の有無         |invited *2                              |
|記述言語           |language *1, *2                         |
|会議種別           |クラスによって自動判定（上書き可）      |
|開催地(日本語)     |address                                 |
|開催地(英語)       |address                                 |
|国際・国内会議     |記述言語から自動判定（上書き可）        |

MISC

| CSV               | BibTex                                 |
|-------------------|----------------------------------------|
|タイトル(日本語)   |title                                   |
|タイトル(英語)     |title                                   |
|著者(日本語)       |author                                  |
|著者(英語)         |author                                  |
|誌名(日本語)       |institution,eprinttype                  |
|誌名(英語)         |institution,eprinttype                  |
|巻                 |volume                                  |
|号                 |number                                  |
|開始ページ         |pages                                   |
|終了ページ         |pages                                   |
|出版年月           |year,month                              |
|査読の有無         |reviewed *1, *2                         |
|招待の有無         |invited *2                              |
|記述言語           |language *1, *2                         |
|掲載種別           |クラスによって自動判定                  |
|ID:DOI             |doi or https://doi.org/... in url or pdf|
|URL                |url                                     |

1. 下記分類により自動決定
2. 下記の独自拡張フィールド

### BibTexエントリーとresearchmap.jp分類の対応関係

* 論文（公開）

  * `@article`: 論文（査読あり，学術雑誌）
  * `@inproceedings`
    * 査読あり: 国際会議を想定．まれに査読あり国内学会もあり
    * 査読なし: 国内研究会などを想定
  * `@phdthesis`: 論文（学位論文（博士））
  * `@masterthesis`: 論文（学位論文（修士）

* 講演・口頭発表等（公開）

  * `@inproceedings`

* Misc（公開）

  * `@techreport`

### 日英の判定

* 著者と誌名いずれかに日本語（`/(?:\p{Hiragana}|\p{Katakana}|[一-龠々])/`）を含むか否か
* 英語の場合，日本語のタイトル・著者・誌名属性には，英語のものが入る

### BibTex拡張フィールド

* `reviewed` → 値が0なら「査読：無」，1なら「査読：有」とする（デフォルトはエントリー種別で自動決定）
* `invited` → 値が0なら「招待：無」，1なら「招待：有」とする（デフォルトは無し）
* `language` → 値がjapaneseまたはjaなら強制的に日本語論文，englishまたはenなら英語論文とする（デフォルトは著者名の文字コードで自動決定）
* `presentation_type` → 「講演・口頭発表等」の「会議種別」を強制的に指定する．

## おまけ

*以下はオリジナル版に搭載されている機能ですが，fork後はメンテナンスされていません．正常に動作しない可能性があります．*

`bib2txt.rb`を使うと，bibからplain textで文献リストを生成できます．要するにBibTexそのもの…ですが，スクリプト的に何か追加処理をする際のテンプレートとして．`.bst`ファイルよりも`.csl`ファイルのほうが編集しやすい，という人向け．逆に`.bst`や`.csl`よりも直接スクリプトを書くほうが早いという人は`bib2csv.rb`を好きなように改造してください．

第１引数はbibファイル，第２引数はCSLファイルの名前．csl-stylesに同梱されているもの（`ieee`や`acm-siggraph`など）でも，カレントディレクトリに自分で用意したファイルでも可．独自の様式にしたい場合は，適当な既存CSLをもとに編集してカレントに置けばOK．

```
$ ruby bib2txt.rb sample.bib ieee
```

## ライセンス

BSD 3-Clause License


