clc
close all
 
FDetect = vision.CascadeObjectDetector;
resim1 = imread('2.jpeg');

%boyut ayarlanıyor
resim=imresize(resim1, [300 320]);

% yüz belirleniyor
BB = step(FDetect,resim);
figure,
subplot(4,4,1);
imshow(resim); hold on
for i = 1:size(BB,1)
rectangle('Position',BB(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
title('yüz belirlendi');
hold off;

% yüz kırpılıyor
yuz=imcrop(resim,BB);
subplot(4,4,2);
imshow(yuz);
title('yüz kırpıldı');

%yüze gaus filtreleme ile canny yapılıyor
yuz_gri=rgb2gray(yuz);
h = fspecial('gaussian',[3 3], 0.5);
yuz_filtre = filter2(h,yuz_gri)/255;
yuz_canny = edge(yuz_filtre(:,:,1),'canny');
subplot(4,4,3);
imshow(yuz_canny);
title('canny yüz');

% ağız belirleniyor
MouthDetect = vision.CascadeObjectDetector('Mouth','MergeThreshold',130);
BBb=step(MouthDetect,yuz);
subplot(4,4,4);
imshow(yuz);
title('ağız belirleme');
hold on
for i = 1:size(BBb,1)
rectangle('Position',BBb(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','r');
end
hold off;

% ağız kırpılıyor
agiz=imcrop(yuz,BBb); %AĞIZ
subplot(4,4,5);
imshow(agiz);
title('ağız kırpıldı');

%ağıza gaus filtreleme ile canny yapılıyor
agiz_gri=rgb2gray(agiz);
h = fspecial('gaussian',[3 3], 0.5);
agiz_filtre = filter2(h,agiz_gri)/255;
agiz_canny = edge(agiz_filtre(:,:,1),'canny');
subplot(4,4,6);
imshow(agiz_canny);
title('canny ağız');

% göz belirleniyor
EyeDetect = vision.CascadeObjectDetector('EyePairBig');
BBa=step(EyeDetect,yuz);
subplot(4,4,7);
imshow(yuz);
title('göz belirlendi');
rectangle('Position',BBa,'LineWidth',1,'LineStyle','-','EdgeColor','b');

% göz kırpılıyor
goz=imcrop(yuz,BBa);
subplot(4,4,8);
imshow(goz);
title('göz kırpıldı');

%göze gaus filtreleme ile canny yapılıyor
goz_gri=rgb2gray(goz);
h2 = fspecial('gaussian',[3 3], 0.5);
goz_filtre = filter2(h2,goz_gri)/255;
goz_canny = edge(goz_filtre(:,:,1),'canny');
subplot(4,4,9);
imshow(goz_canny);
title('canny göz');

% burun belirleniyor
NoseDetect = vision.CascadeObjectDetector('Nose','MergeThreshold',45);
BBs=step(NoseDetect,yuz);
subplot(4,4,10);
imshow(yuz); hold on
for i = 1:size(BBs,1)
rectangle('Position',BBs(i,:),'LineWidth',1,'LineStyle','-','EdgeColor','b');
end
title('burun belirleniyor');
hold off;

% burun kırpılıyor
burun=imcrop(yuz,BBs);
subplot(4,4,11);
imshow(burun);
title('burun kırpıldı');

% buruna gaus filtreleme ile canny yapılıyor
burun_gri=rgb2gray(burun);
h3 = fspecial('gaussian',[3 3], 0.5);
burun_filtre = filter2(h3,burun_gri)/255;
burun_canny = edge(burun_filtre(:,:,1),'canny');
subplot(4,4,12);
imshow(burun_canny);
title('canny burun');

%göz pixellerinin sayımı
bw1=bwareaopen(goz_canny,50);
subplot(4,4,13);
imshow(bw1);
title('göz pixelin sayımı')
gozpixelsayisi=bwconncomp(goz_canny,4);
goz_deger = bweuler(goz_canny,8);

%ağız pixellerinin sayımı
bw2 = bwareaopen(agiz_canny, 50);
subplot(4,4,14);
imshow(bw2);
title('agiz pixelin sayimi');
dudakpixelsayisi = bwconncomp(agiz_canny,8);
agiz_deger = bweuler(agiz_canny,8);

% burun pixellerinin sayımı
bw3 = bwareaopen(burun_canny, 50);
subplot(4,4,15);
imshow(bw3);
title('burun pixelin sayimi');
burunpixelsayisi = bwconncomp(burun_canny,8);
burun_deger = bweuler(burun_canny,8);

%yüz pixellerinin sayımı
bw3 = bwareaopen(yuz_canny,50);
subplot(4,4,16);
imshow(bw3);
title('yuz pixelin sayimi');
yuz_pixelsayisi = bwconncomp(yuz_canny,8);
yuz_deger = bweuler(yuz_canny,8);
 
goz_agiz_toplam= goz_deger+agiz_deger;
goz_burun_toplam= burun_deger+agiz_deger;
goz_agiz_burun_toplam= goz_deger+agiz_deger+burun_deger;
 
% oranlamalar
goz_yuz_orani= goz_deger/yuz_deger
agiz_yuz_orani= agiz_deger/yuz_deger
burun_yuz_orani= burun_deger/yuz_deger
goz_agiz_yuz_orani= goz_agiz_toplam/yuz_deger
goz_burun_yuz_orani= goz_burun_toplam/yuz_deger
goz_agiz_burun_yuz_orani= goz_agiz_burun_toplam/yuz_deger
 
fark1=goz_agiz_burun_yuz_orani-goz_burun_yuz_orani
fark2=goz_agiz_burun_yuz_orani-burun_yuz_orani
fark3=goz_agiz_burun_yuz_orani-goz_yuz_orani




if((burun_yuz_orani>0.29)||(goz_agiz_yuz_orani>0.51)||(goz_burun_yuz_orani>0.51)||(goz_agiz_burun_yuz_orani>0.7274))
    figure,imshow(resim);
    age = 1 * (goz_agiz_burun_toplam) 
      X = ['Cinsiyet=Bayan', ' || ' ,'Yaş=',num2str(age)];
   title(X);
        disp(X);
else if((fark1<0.2274 || fark3>0.37))
     age = 1 * (goz_agiz_burun_toplam) 
  figure,imshow(resim);
 X = ['Cinsiyet=Erkek', ' || ' ,'Yaş=',num2str(age)];
  title(X);
        disp(X);
    else
   figure,imshow(resim);
age = 1 * (goz_agiz_burun_toplam / 2) 
 X = ['Cinsiyet=Bayan', ' || ' ,'Yaş=',num2str(age)];
   title(X);
        disp(X);
end
end

