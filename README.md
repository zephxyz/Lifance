
# Můj projekt

Cílem projektu je vyvinout mobilní aplikaci, která bude sloužit jako nástroj pro podporu rovnováhy mezi prací a odpočinkem. Aplikace bude umožňovat přihlašování, registraci, odhlašování a odstraňování profilů uživatelů. Bude zahrnovat mapu, na které uživatelé budou moci zjišťovat cíle vybrané aplikací. Každý den bude k dispozici nová "výzva", která přidá na mapu náhodný bod v určité vzdálenosti od uživatele. Uživatel může zahájit "výzvu" stisknutím tlačítka a zvolit, zda chce ujít více než minimální vzdálenost. Minimální vzdálenost se bude dynamicky zvyšovat s počtem úspěšně dokončených "výzev". Uživatel může "výzvu" splnit, pokud se dostane do radiusu 50 metrů od cíle "výzvy". Po splnění "výzvy" bude uživatel vyzván k pořízení fotografie místa, kde se nachází, a obdrží odměnu ve formě symbolů "🔥", které představují počet úspěšně dokončených "výzev" v řadě. Aplikace bude také obsahovat možnost zahájit další výzvu po dokončení předchozí. Pro uživatele bude k dispozici nápověda a návod, jak aplikaci používat. Bude také možné nastavit upozornění, která budou uživatele vybízet k tomu, aby se připravili na další "výzvu" nebo aby se rozhodli pro odpočinek. Celkově tedy cílem projektu je vyvinout aplikaci, která pomůže uživatelům udržovat rovnováhu mezi prací a odpočinkem prostřednictvím aktivit navržených v aplikaci.

## Popis funkcí

- Přihlašování/registrace/odhlašování/odstranění profilu: Uživatelé se musí přihlásit do aplikace, aby ji mohli používat. Toto slouží především k ukládání progresu a případným leaderboardům.

- Mapa: Použitím mapy, která je umístěná v aplikaci, mohou uživatelé zjišťovat cíle, které aplikace vybere.

- Horní panel: Je rozdělen do dvou částí. Levá část zobrazuje počet "🔥", pravá část zobrazuje aktuální minimální vzdálenost.

- Dolní panel, pokud se uživatel nachází na "Zobrazení profilu" nebo "Zobrazení historie": Je rozdělen do tří částí. Vlevo se nachází tlačítko "Zobrazení profilu", uprostřed se nachází tlačítko "Výzvy" a vpravo se nachází tlačítko "Zobrazení historie".

- Dolní panel, pokud se uživatel nachází na "Výzvy": Je rozdělen do dvou částí. Vlevo se nachází tlačítko "Zobrazení profilu" a vpravo se nachází tlačítko "Zobrazení historie".

- Tlačítko "Zahájení denní výzvy": Je umístěné na "Výzvy". Tlačítko má tvar kruhu. Střed tlačítka je na průsečíku okrajů tlačítek dolního panelu. Po zahájení výzvy se barva tlačítka změní a po dokončení se změní zpět.

- Denní výzva (dále jen "výzva"): Každý den je k dispozici nová "výzva", která přidá na mapu náhodný bod v zvoleném radiusu (pokud není zvolen, použije se default radius) od uživatele. Uživatel může zahájit "výzvu" stisknutím tlačítka umístěného na dolním panelu a zvolit, zda chce ujít více než minimální vzdálenost. Minimální vzdálenost je původně nastavena na 300 metrů a bude se dynamicky zvyšovat s počtem úspěšně dokončených "výzev". Uživatel může "výzvu" splnit, pokud se dostane do radiusu 50 metrů od cíle "výzvy". Po zahájení "výzvy" se tlačítko "Zahájit denní výzvu" změní na tlačítko "Změna cíle". Pokud bude cíl nedosažitelný, uživatel může požádat o změnu cíle pomocí tohoto tlačítka. Změna cíle se provede na základě vzdálenosti od uživatele ke stávajícímu cíli a vybere náhodně v radiusu od uživatele s touto vzdáleností. Uživatel může požádat o změnu cíle pouze jednou za 1 minutu. Po splnění "výzvy" uživatel obdrží výzvu k pořízení fotografie místa, kde se nachází. Aplikace také odmění uživatele s "🔥", které symbolizují počet úspěšně dokončených "výzev" v řadě (streaks). Po dokončení "výzvy" může uživatel zahájit další výzvu. Každá další výzva zatím uživatele nijak neodměňuje. Pokud uživatel vynechá den "výzvy", jeho "🔥" spadne na 0 a minimální vzdálenost se vyresetuje na 300 metrů.

- Zobrazení historie: Uživatel může zobrazit historii svých denních výzev a fotografií z nich pomocí tlačítka nacházejícího se vpravo od tlačítka spuštění denní výzvy. Vpravo uprostřed se nachází switch pro fotky/místa. Pokud je zvoleno zobrazení fotek, zobrazí se galerie fotografií. Pokud je zvoleno zobrazení míst, zobrazí se mapa s navštívenými místy.

- Zobrazení profilu: Uživatel může zobrazit svůj profil pomocí tlačítka nacházejícího se vlevo od tlačítka spuštění denní výzvy. Na profilu se zobrazí uživatelovo jméno, profilový obrázek, počet "🔥", minimální vzdálenost, celková vzdálenost, kterou uživatel ušel, datum založení profilu a tlačítko pro vymazání profilu.

## Technologie

- Flutter a Dart: Flutter je open-source framework pro vývoj multiplatform aplikací. Používá jazyk Dart jako hlavní programovací jazyk a poskytuje širokou škálu knihoven a widgetů pro vývoj kvalitních aplikací s atraktivním vzhledem a uživatelským rozhraním. Flutter je často využíván pro vývoj aplikací s vysokou mírou interakce s uživatelem, jako jsou například hry nebo sociální sítě. Jeho hlavní předností je rychlost vývoje, která je díky funkci hot reload vyšší než u jiných frameworků.

Vybral jsem si Flutter, protože se ho chci naučit.

- fleaflet/flutter_map package: flutter_map je package pro Flutter, který umožňuje vytváření interaktivních map v aplikacích. Je založen na Leaflet, open-source JavaScript knihovně pro tvorbu webových map. Flutter Map umožňuje zobrazování map z různých zdrojů, jako je OpenStreetMap nebo mapy od společností Google a Mapbox. flutter_map je dobrou volbou pro vývoj aplikací, které potřebují zobrazovat mapy nebo pracovat s geografickými údaji.

Vybral jsem si flutter_map, protože dokáže pracovat s geografickými údaji (a nechci platit za Google mapy).

- Firebase: Firebase je cloudová platforma pro vývoj aplikací, která poskytuje širokou škálu služeb pro back-end aplikací, jako je správa databází, autentifikace uživatelů nebo analytika. 

Vybral jsem si Firebase, protože stejně jako Flutter je od společnosti Google - je velmi dobře integrován s Flutterem. Navíc se chci Firebase naučit.

- Figma

Vybral jsem si Figmu, protože nabízí široké spektrum nástrojů pro navrhování.

## Časové rozvržení (aktuálně)

### MAIN
- Rámcová analýza (15. ledna)
- Návrh UI (19. ledna)
- Autentifikace uživatele (26. ledna)

### STRANA "výzva"
- Přidat mapu do UI (31. ledna)
- Funkce vypočítání místa pro denní výzvu (9. února)
- Horní panel - zobrazení streaku a radiusu (12. února)
- Dolní panel - přidat tlačítka pro změnu stránky (16. února)
- Funkce tlačítka "Zahájit denní výzvu" (19. února)
- Sledování polohy při denní výzvě (2. března)
- Funkce po dokončení denní výzvy (12. března)

### STRANA "Zobrazení profilu"
- Zobrazení profilových informací (19. března)
- Tlačítko "Odhlásit se" (23. března)
- Funkce "Odhlásit se" (26. března)
- Tlačítko "Smazat účet" (30. března)
- Funkce "Smazat účet" (2. dubna)
- Dolní panel - 3 tlačítka pro změnu strany (6. dubna)

### STRANA "Zobrazení historie"

#### Zobrazení historie (mapa)
- Přidat mapu (9. dubna)
- Zobrazit na mapě historii míst podle uložených souřadnic (16. dubna)
- Horní panel - zobrazení streaku, radiusu (18. dubna)
- Dolní panel - 3 tlačítka pro změnu strany (19. dubna)
- Tlačítko změnit zobrazení* (23. dubna)

#### Zobrazení historie (fotografie)
- Funkce pro získání uložených fotografií (30. dubna)
- Zobrazení fotografií od nejmladší po nejstarší s indexy (7. května)
- Možnost zvětšení fotografií (11. května)
- Horní panel - zobrazení streaku, radiusu (12. května)
- Dolní panel - 3 tlačítka pro změnu strany (13. května)
- Tlačítko změnit zobrazení* (16. května)

*zanedbatelné, stejnou funkci bude mít tlačítko "Zobrazení historie" na straně "Zobrazení historie"

## UML Diagramy

### STRANA "výzva" (DÁLE JEN "main")

#### main a auth

[![](https://github.com/zephxyz/tg-project/blob/main/img/mainauth.drawio.png?raw=true)](https://github.com/zephxyz/tg-project/blob/main/img/mainauth.drawio.png?raw=true)

#### main functions

[![](https://github.com/zephxyz/tg-project/blob/main/img/final%20main%20func.drawio.png?raw=true)](https://github.com/zephxyz/tg-project/blob/main/img/final%20main%20func.drawio.png?raw=true)

### STRANA "Zobrazení profilu"

[![](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20profilu.drawio.png?raw=true)](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20profilu.drawio.png?raw=true)

### STRANA "Zobrazení historie"

#### Zobrazení historie (mapa)

[![](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20historie.drawio.png?raw=true)](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20historie.drawio.png?raw=true)

#### Zobrazení historie (fotografie)

[![](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20historie%20photo.drawio.png?raw=true)](https://github.com/zephxyz/tg-project/blob/main/img/final%20Zobrazeni%20historie%20photo.drawio.png?raw=true)

