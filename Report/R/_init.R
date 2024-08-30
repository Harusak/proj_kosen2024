# データ操作・解析関連のパッケージ
listOfLibraries <- c(
  "tidyverse",  # データ操作・解析全般
  "broom",      # モデル出力を整形するためのパッケージ
  "here",       # プロジェクトのルートディレクトリを簡単に指定
  "knitr"       # xfun >= 4.4
)

# 統計解析用パッケージ
listOfLibraries <- c(listOfLibraries,
                     "car"  # ルービン検定など
)

# 表作成用パッケージ
listOfLibraries <- c(listOfLibraries,
                     "gt"  # gtTable の作成
)

# グラフィックス関連のパッケージ
listOfLibraries <- c(listOfLibraries,
                     "ggplot2",    # 高機能なデータ可視化
                     "ggdist",
                     "ggforce",    # ggplot2 の拡張機能
                     "ggthemes",   # さまざまなテーマを提供するパッケージ
                     "ggpubr",     # パブリケーション品質の図を作成
                     "cowplot",    # 複数のプロットを組み合わせるためのパッケージ
                     "showtext",   # 図にカスタムフォントを追加
                     "latex2exp",  # LaTeX 数式をプロットに追加
                     "magick",      # 画像処理のためのパッケージ
                     "papaja"
)

# コンフリクト管理パッケージ
listOfLibraries <- c(listOfLibraries,
                     "conflicted"  # 名前の衝突を防ぐためのパッケージ
)

# パッケージの読み込み
for(lib in listOfLibraries){
  if (!require(lib, character.only = TRUE)) {
    install.packages(lib)
    library(lib, character.only = TRUE)
  } else {
    library(lib, character.only = TRUE)
  }
}
