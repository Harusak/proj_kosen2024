# データの読み込み
df <- read.csv(here("data/sample/experiment_data.csv"))

# 各subIDのConditionごとの平均値の計算
df_avg <- df %>%
  group_by(subID, Condition) %>%
  summarise(Value = mean(Value))

# データの要約統計量の計算
df_summary <- df_avg %>%
  group_by(Condition) %>%
  summarise(
    Mean = mean(Value),
    SE = sd(Value) / sqrt(n())
  )


# グラフ描画用のカラーセットを定義
colorset = c('Condition1'='#EF9873','Condition2'='#73C9EF');


# 棒グラフを作成
barplot <- ggplot() +
  geom_bar( # 棒グラフの描画
    data = df_summary,
    aes(x = Condition, y = Mean, fill = Condition),
    stat = "identity",
    position = position_dodge(),
    width = 0.5) +
  geom_errorbar( # エラーバーの描画
    data = df_summary,
    aes(x = Condition, ymin = Mean - SE, ymax = Mean + SE),
    width = 0.2,
    position = position_dodge(0)) +
  geom_line( # データポイントを結ぶ線の描画
    data = df_avg,
    aes(x = Condition, y = Value, group = subID),
    color = "#2B4257",
    position = position_dodge(width = 0),
    alpha = 0.2) +
  ggdist::stat_dots( # データポイントを描画
    data = df_avg,
    aes(x = Condition, y = Value, fill = Condition),
    side = "both",
    justification = 0.5,
    binwidth = 0.15,
    alpha = 0.7,
    colour = "#2c2d3f"
  ) +
  scale_fill_manual(values = colorset) + # `fill=Condition` のようにした箇所の実際の値を指定
  scale_color_manual(values = colorset) + # `color=Condition` の箇所も同様
  scale_x_discrete(limits = c("Condition1", "Condition2")) + # x軸の指定
  labs(
    x=NULL, # 非表示にもできる
    y='Value'
  ) +
  theme_apa(base_size=22, base_family="Times", box=TRUE) +
  theme( # その他描画設定
    legend.position = "none", # 凡例を非表示 (必要な場合は設定しよう)
    panel.border = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.line = element_line(colour = "black"),
    )
# プロットの表示範囲を取得
ggbuild <- ggplot_build(barplot)
x_range <- ggbuild$layout$panel_params[[1]]$x.range
y_range <- ggbuild$layout$panel_params[[1]]$y.range

# 指定した範囲を使ってアスペクト比を計算
ratio.values <- (x_range[2] - x_range[1]) / (y_range[2] - y_range[1])
ratio.display <- 1

# 最終プロットの作成
barplot <- barplot +
  coord_fixed(ratio.values / ratio.display)