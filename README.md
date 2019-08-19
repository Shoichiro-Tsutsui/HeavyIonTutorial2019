# これは何？
チュートリアル研究会「高エネルギー重イオン衝突の物理：基礎・最先端・課題・展望」の格子QCD講演で紹介したサンプルコードと参考資料を公開しています。

# 体験！符号問題
被積分関数が激しく振動する関数の場合に、モンテカルロ法を適用すると何が起きるかを体験できます。
signprob.nb, signprob.py, signprob.jl はそれぞれ、mathematica, python, juliaのサンプルコードです。

# ハイブリッドモンテカルロ法
上の例では、簡単のため、確率変数が標準正規分布に従う場合を扱っていますが、
実は、任意の確率分布に従う確率変数を生成することも可能です。
そのようなアルゴリズムの一つが、ハイブリッドモンテカルロ(HMC)法であり、実際の格子QCD計算でも採用されています。
サンプルコードは hmc.jl, 簡単な解説が mc.pdf にあります。

## hmc.jl の解説
hmc.jl は[Julia言語](https://julialang.org/)で書かれています。

作用、ドリフト項（作用の微分）を

```julia
 action(x) = sum(x.^2/2)
 drift(x) = -x
```

のように指定して、

```julia
 conf = hybrid_montecarlo(action, drift, dof, Nsample)
```

とすると、確率変数が`Nsample`個生成されます。
ここで、`dof`は力学変数の自由度の数です。(例えば100と指定すると、`x`が100成分のベクトルであると見做されます。)
次に、計算したい物理量を

```julia
 obs(x) = sum(x.^2)
```
とすると、その期待値は、

```julia
 mean(obs.(conf))
```

で得られます。

## hmc.jl の実行方法
(1) ターミナルを開いて

```shell
 julia hmc.jl
```
と打つ。

(2) [Juno](https://junolab.org/) をインストールすると、mathematicaやJupyterのように、ターミナルを開かずコードブロックごとに実行できる。

(*)パッケージ Statistics, Random, Distributions がインストールされている必要があります。


# python のインストール
[Anaconda](https://www.anaconda.com/): python本体に加えて、数値計算で必要になるライブラリたちをまとめてインストールできる。

# Julia のインストール
[公式サイト](https://julialang.org/)からダウンロードできる。

## パッケージ（ライブラリ）の追加方法
ターミナルからJuliaを起動する。

```shell
> julia
```

`]`と入力して、パッケージ管理モードに入る。

```julia
julia> ]
```

`add("hoge")` で`hoge`という名前のパッケージがインストールできる。

```julia
(v1.1) pkg> add("hoge")
```

パッケージ管理モードを終了するには、`Ctrl + c`を入力します。
