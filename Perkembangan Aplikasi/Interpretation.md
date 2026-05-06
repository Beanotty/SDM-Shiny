---
title: "Perkenalan Ke Website"
author: "Reyza"
date: "5/25/2025"
output: 
  html_document:
    mathjax: local
    self_contained: false
---




<table class="table table-hover" style="color: black; width: auto !important; margin-left: auto; margin-right: auto;">
 <thead>
  <tr>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Variabel </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Dampak Wilayah sendiri </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Koefisien Taksiran </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Dampak dari Wilayah Tetangga </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Koefisien Taksiran Tidak Langsung </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Signifikansi Total </th>
   <th style="text-align:center;font-weight: bold;border-bottom: 2px solid black;border-top: 2px solid black"> Dampak Total </th>
  </tr>
 </thead>
<tbody>
  <tr>
   <td style="text-align:center;"> Intersep </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> NA </td>
   <td style="text-align:center;"> 0.0617476 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Keterlibatan Perempuan di Parlemen (Persen) </td>
   <td style="text-align:center;"> Signifikan </td>
   <td style="text-align:center;"> -0.00455 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.000087 </td>
   <td style="text-align:center;"> Signifikan </td>
   <td style="text-align:center;"> -0.0044600 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Perempuan sebagai Tenaga Profesional (Persen) </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.00042 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.000790 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.0012600 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Prevalensi Ketidakcukupan Konsumsi Pangan (Persen) Per Kabupaten/kota (Persen) </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> 0.00110 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.001430 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.0003600 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Melahirkan Anak Lahir Hidup Yang Pertama Kali Berumur Kurang dari 20 tahun </td>
   <td style="text-align:center;"> Signifikan </td>
   <td style="text-align:center;"> 0.83688 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.078900 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> 0.7580000 </td>
  </tr>
  <tr>
   <td style="text-align:center;"> Sumbangan Pendapatan Perempuan (Persen) </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.00073 </td>
   <td style="text-align:center;"> Tidak Signifikan </td>
   <td style="text-align:center;"> -0.002860 </td>
   <td style="text-align:center;"> Signifikan </td>
   <td style="text-align:center;"> -0.0036000 </td>
  </tr>
  <tr>
   <td style="text-align:center;border-bottom: 2px solid black"> Angka Kelahiran Total </td>
   <td style="text-align:center;border-bottom: 2px solid black"> Signifikan </td>
   <td style="text-align:center;border-bottom: 2px solid black"> 0.07304 </td>
   <td style="text-align:center;border-bottom: 2px solid black"> Signifikan </td>
   <td style="text-align:center;border-bottom: 2px solid black"> 0.086320 </td>
   <td style="text-align:center;border-bottom: 2px solid black"> Signifikan </td>
   <td style="text-align:center;border-bottom: 2px solid black"> 0.1593700 </td>
  </tr>
</tbody>
</table>
#### Apa itu Tetangga?
Tetangga merupakan satu poin dalam data yang mempunyai kedekatan dengan poinlainnnya. Dalam penelitian ini satu wilayah (poin) akan mempunyai maksimum 5 tetangga (wilayah yang berdekatan).


#### $X_1$ (Persentase perempuan bekerja dalam Parlemen)
1. Dampak dari Wilayah Sendiri : Kenaikan satu unit $X_1$ dalam suatu wilayah ketika semua variabel independen di wilayah tersebut dan wilayah tetangga konstan, menyebabkan penurunan IKG sebesar $0.00455$ dalam wilayah yang berkaitan.
2. Dampak Total : Secara total, Kenaikan satu unit  $X_1$ dalam suatu wilayah dan diluar wilayah ketika semua variabel independen lain di wilayah tersebut dan wilayah tetangga konstan, menyebabkan penurunan IKG sebesar $0.00446$ dalam wilayah yang berkaitan.
 

#### $X_4$ (Proporsi Perempuan Melahirkan Anak Lahir Hidup Yang Pertama Kali Berumur Kurang dari 20 tahun)
1. Dampak dari Wilayah Sendiri : Kenaikan satu unit $X_4$ dalam suatu wilayah ketika semua variabel independen di wilayah tersebut dan wilayah tetangga konstan, menyebabkan kenaikan IKG sebesar $0.83688$ dalam wilayah yang berkaitan.
2. Dampak Total : Secara total, Kenaikan satu unit $X_4$ dalam suatu wilayah dan diluar wilayah ketika semua variabel independen lain di wilayah tersebut dan wilayah tetangga konstan, menyebabkan kenaikan IKG sebesar $0.758$ dalam wilayah yang berkaitan 

	
#### $X_6$ (Angka Kelahiran Total)
1. Dampak dari Wilayah Sendiri : Kenaikan satu unit $X_6$ dalam suatu wilayah ketika semua variabel independen di wilayah tersebut dan wilayah tetangga konstan, menyebabkan kenaikan IKG sebesar $0.07304$ dalam wilayah yang berkaitan.
2. Dampak Dari Wilayah Tetangga : Kenaikan satu unit $X_6$ diluar suatu wilayah ketika semua variabel independen dalam suatu wilayah dan wilayah tetangga konstan, menyebabkan kenaikan IKG sebesar $0.08632$ dalam wilayah yang berkaitan.
3. Dampak Total : Secara total, Kenaikan satu unit $X_6$ dalam suatu wilayah dan diluar wilayah ketika semua variabel independen lain di wilayah tersebut dan wilayah tetangga konstan, menyebabkan kenaikan IKG sebesar $0.15937$ dalam wilayah yang berkaitan.

