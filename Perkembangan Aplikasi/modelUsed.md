---
title: "About model yang digunakan"
author: "Reyza"
date: "5/15/2025"
output: 
  html_document:
    mathjax: local
    self_contained: false
---



# Model yang digunakan

Pemodelan Statistika yang digunakan merupakan model _Spatial Durbin Model_ (SDM), SDM dapat dinotasikan sebagai : 

$$y =  \rho \textbf{WY} + X\mathbf{\beta} + \textbf{WX} \mathbf{\theta} +  \epsilon$$

## Mengapa Model Durbin Spatial Unggul?
Menurut Penelitian yang dilaksanakan oleh (Rüttenauer, 2022; Koley & Bera, 2022), model yang menggunakan pengaruh spatial pada $X$ dan $Y$ lebih unggul dibandingkan regresi linear karena dapat membantu menjelaskan dampak wilayah sendiri _(direct effect)_ dan wilayah tetangga _(indirect effect)_ dari ketergantungan spatial dalam data. 



## Model Akhir
$$\begin{align*}
y &= 0.4614 WY + X \begin{bmatrix}
0.06116\\
-0.004615\\
-0.000916\\
0.000693\\
0.8275\\
-0.000492\\
0.06301
\end{bmatrix}

+ WX \begin{bmatrix}
0.00187\\
0.00052\\
-0.00059\\
-0.41187\\
-0.00102\\
0.009291
\end{bmatrix}
\end{align*}$$



