(:for $k in doc('file:///E:/PUT/ZTPD2/XPath-XSLT/swiat.xml')/SWIAT/KRAJE/KRAJ:)
(:where starts-with($k/NAZWA, 'A'):)

(:where starts-with($k/NAZWA, substring($k/STOLICA,1,1 )):)
(:return <KRAJ>:)
(: {$k/NAZWA, $k/STOLICA}:)
(:</KRAJ>:)

(:doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml'):)
(:doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//NAZWISKO:)
(:doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW[NAZWA='SYSTEMY EKSPERCKIE']/PRACOWNICY/ROW/NAZWISKO:)
(:count(doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW[ID_ZESP=10]/PRACOWNICY/ROW/NAZWISKO):)
(:doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW/PRACOWNICY/ROW[ID_SZEFA=100]/NAZWISKO:)
sum(doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW/PRACOWNICY/ROW[ID_ZESP=doc('E:/PUT/ZTPD2/XPath-XSLT/zesp_prac.xml')//ZESPOLY/ROW/PRACOWNICY/ROW[NAZWISKO='BRZEZINSKI']/ID_ZESP
    ]/PLACA_POD)


