
# Fifth-Week-Homework

## BreakingBadApp - Episode Notes
Breaking Bad App, Breaking Bad karakterlerinin bilgilerini, repliklerini, sezon bölümlerinin bilgilerini ve bölümlerde oynayan karakterleri gösteren, dizinin IMDB sayfasının incelenebildiği ve bölümlerle ilgili notlar alınabilen bir uygulamadır.
- Geçtiğimiz hafta yapılan projenin üzerine Episode Notes Tab'ı eklenmiştir.

### Episode Notes Tab

- Episode Notes Tab'da CoreData'ya eklenen notlar listelenir, yeni not eklenebilir, eklenen notlar güncellenebilir ve silinebilir.

<div align="center">
<table>
<tr>
<td><img src="https://user-images.githubusercontent.com/96587699/205512153-238dd1e9-eda1-4423-a8b8-ecd02e9e7e3f.png" alt="drawing" width="275"/></td>  
<td><img src="https://user-images.githubusercontent.com/96587699/205512162-1ef8ecbf-1390-4d3d-b0b1-7afa07a1d22b.png" alt="drawing" width="275"/></td>  
</td>  
</tr>
</table>
</div>

- Note Tab ana ekranında CoreData'ya kayıtlı notlar sezon ve bölüm sıralamasına göre listelenir.
- Listelenen notlar sola kaydırılarak CoreData ve TableView'den silinebilir.
- Ana ekranda ekle butonuna tıklanarak boş şekilde not ekle/düzenle ekranı present edilir.
- Tableview'de listelenen kayıtların üzerine tıklandığında ekle/düzenle ekranı dolu şekilde present edilir.

<div align="center">
<table>
<tr>
<td><img src="https://user-images.githubusercontent.com/96587699/205512164-0df1be8a-a6da-47db-b263-16edcb228ddc.png" alt="drawing" width="275
"/></td>  
<td><img src="https://user-images.githubusercontent.com/96587699/205512158-f8350279-e73a-45dd-b75d-5bfdd5a3e142.png" alt="drawing" width="275
"/></td>  
<td><img src="https://user-images.githubusercontent.com/96587699/205512160-cb05f72b-6a00-4a88-ba4e-80073e009b23.png" alt="drawing" width="275
"/></td>  
</tr>
</table>
</div>

- Ekle butonuna basıldığında boş bir kayıt ekranı açılır.
- Season & Episode seçim texfield'ından 2'li pickerview ile sezon ve bölüm seçimi yapılır.
- Pickerview'de bulunan sezon ve bölüm bilgileri API'dan alınır. Yeni bir sezon, bölüm eklemesi yapılırsa yeni sezon ve bölümler otomatik eklenmiş olur.
- Seçim yapılan bölüm için daha önce kayıt girilmiş ise seçim sonrasında textview'e önceki girilen kayıt gelir. Kayıt üzerinde ekleme ve düzenleme yapılabilir.
- Kayıt bittiğinde klavyenin üzerinde bulunan done butone ile klavye kapatılabilir.
- Save butonu ile girilen not CoreData'ya kayıt yapılır ve listeye eklenir, close butonu ile herhangi bir aksiyon almadan ekran dismiss edilebilir.
- Klavye veya picker açıkken ekranın farklı bir yerine dokunulduğunda klavye ve picker Gesture Recognizer ile kapatılır.
- Listeleme ekranında tableview cell üzerine tıklandığında dolu şekilde ekle/düzenle ekranı açılır. Düzenleme için açılan ekranda bölüm değişimi yapılmaması için bölüm textfield'ı disable edilmiştir. Düzenleme yapıldıktan sonra save edilerek not güncellenmiş olur.
