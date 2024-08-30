# Required
## R 環境
- R version: > 4.2.x
- RTools: > 4.2 (R version にあったもの)

## Latex 環境 (レポート化に必要)
- tinytex
  - RMarkdown でTexを使ったレンダリングを行う
- bookdown
  - https://bookdown.org/yihui/bookdown/get-started.html
  - 文書内での相互参照など

```{r}
# Rコンソールで以下を実行
install.packages(c('tinytex', 'bookdown'))
tinytex::install_tinytex()
tinytex::tlmgr_install("xetex")
```

## フォント環境 (レポート化に必要)
- IPA フォント
  - [IPA フォント](https://moji.or.jp/ipafont/ipa00303/) から4書体パック(Ver.003.03)を入手
  - インストールが必要のため，[ここ](https://moji.or.jp/ipafont/installation/)を参照

```{r}
# 必要であればコンソールで実行 (多分しなくていいと思う...)
tinytex::tlmgr_install("ipaex")
```

- フォントその他
  - ヒラギノやNotoなどがシステムにインストールされて使用可能な場合，`/Report/etc/_preamble.tex` から設定可

# Usage

## 解析データ
本実習の解析には，Open Science Framework (OSF) に公開されている Michael Makoto Martinsen による Facial Ambiguity and Perception: How Face-Likeness Affects Breaking Time in Continuous Flash Suppression の実験データを使用する．[[1]](#1)

データは [https://osf.io/jes4u/](url) からダウンロードし，解析を行う．
提供されるデータは以下のような構造となっている．(3階層以降を省略)
`Facelikeness/analysis/raw` ディレクトリを当プロジェクトにおける`Report/data/raw` に上書きする．

``` tree
Facelikeness
├── 00_CFS_facelikeness_paper.Rproj
└── analysis
    ├── analysis_part0.Rmd
    ~~~
    ├── analysis_part4_targetID.html
    ├── function - ~~~
    ├── processed - ~~~
    ├── raw <!-- このディレクトリを`Report/data/raw` に上書き -->
    │   ├── binary.csv
    │   ├── experiment_main
    │   ├── experiment_survey
    │   └── mondrian
    └── results - ~~~
```

## 解析スクリプト
- `Report/analysis` 内の`part_0*.rmd` を編集
  - `part_01.rmd` : データ整形
  - `part_02.rmd` : データ可視化
  - `part_03.rmd` : 統計解析

## レポート (必要であれば)
- `Report/report.rmd` をコンパイル → レポート化
  - `/Report/R/_compiler.r` を実行

```r
source(here("R/_compiler.r"))
```

# Reference
<a id="1">[1]</a> Martinsen, M. M. (2024, August 24). Facial Ambiguity and Perception: How Face-Likeness Affects Breaking Time in Continuous Flash Suppression. Retrieved from osf.io/jes4u