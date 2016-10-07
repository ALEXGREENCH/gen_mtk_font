if exist fontfile rd /s /q fontfile 
if exist font rd /s /q font 

md fontfile
md font

copy /y bdf\%1 font
copy /y bdf\%2 font
copy /y bdf\%3 font
copy /y bdf\%4 font

ren  font\%1 latin_small.bdf
ren  font\%2 latin_medium.bdf
ren  font\%3 latin_dialer.bdf
ren  font\%4 GB2312.bdf

.\font_gen.exe

.\font_m.pl .\FontFile %5 %6