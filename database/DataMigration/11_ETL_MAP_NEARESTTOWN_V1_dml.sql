/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT ID, [Town Name] 
FROM tblTowns
ORDER BY [Town Name]

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME 
FROM CRT_CODE_LOOKUP 
WHERE CODE_SET = 'NEARST_TWN'
ORDER BY CODE_NAME

***/

BEGIN TRANSACTION
IF OBJECT_ID('dbo.MAP_NEAREST_TWN', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_NEAREST_TWN;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_NEAREST_TWN
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]

COMMIT
GO

BEGIN TRANSACTION
SET NOCOUNT ON;

INSERT INTO MAP_NEAREST_TWN VALUES (23, 37);  --100 Mile House > 100 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (309, 38);  --150 Mile House > 150 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (40, 39);  --70 Mile > 70 Mile
INSERT INTO MAP_NEAREST_TWN VALUES (43, 40);  --70 Mile House > 70 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (217, 41);  --Abbotsford > Abbotsford
INSERT INTO MAP_NEAREST_TWN VALUES (312, 42);  --Adams Lake > Adams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (80, 43);  --Agassiz > Agassiz
INSERT INTO MAP_NEAREST_TWN VALUES (212, 44);  --Aldergrove > Aldergrove
INSERT INTO MAP_NEAREST_TWN VALUES (176, 45);  --Alexis Creek > Alexis Creek
INSERT INTO MAP_NEAREST_TWN VALUES (171, 46);  --Anahim Lake > Anahim Lake
INSERT INTO MAP_NEAREST_TWN VALUES (33, 47);  --Armstrong > Armstrong
INSERT INTO MAP_NEAREST_TWN VALUES (233, 48);  --Ashcroft > Ashcroft
INSERT INTO MAP_NEAREST_TWN VALUES (283, 49);  --Atlin > Atlin
INSERT INTO MAP_NEAREST_TWN VALUES (134, 50);  --Balfour > Balfour
INSERT INTO MAP_NEAREST_TWN VALUES (279, 51);  --Bamfield > Bamfield
INSERT INTO MAP_NEAREST_TWN VALUES (168, 52);  --Barkerville > Barkerville
INSERT INTO MAP_NEAREST_TWN VALUES (118, 53);  --Barriere > Barriere
INSERT INTO MAP_NEAREST_TWN VALUES (144, 54);  --Beaverdell > Beaverdell
INSERT INTO MAP_NEAREST_TWN VALUES (174, 55);  --Bella Coola > Bella Coola
INSERT INTO MAP_NEAREST_TWN VALUES (237, 56);  --Blaeberry > Blaeberry
INSERT INTO MAP_NEAREST_TWN VALUES (298, 57);  --Blind Bay > Blind Bay
INSERT INTO MAP_NEAREST_TWN VALUES (113, 58);  --Blue River > Blue River
INSERT INTO MAP_NEAREST_TWN VALUES (240, 59);  --Boston Bar > Boston Bar
INSERT INTO MAP_NEAREST_TWN VALUES (135, 60);  --Boswell > Boswell
INSERT INTO MAP_NEAREST_TWN VALUES (305, 61);  --Bowser > Bowser
INSERT INTO MAP_NEAREST_TWN VALUES (248, 62);  --Bridge Lake > Bridge Lake
INSERT INTO MAP_NEAREST_TWN VALUES (21, 63);  --Britannia Beach > Britannia Beach
INSERT INTO MAP_NEAREST_TWN VALUES (300, 64);  --Burnaby, Delta, West Van > Burnaby, Delta, West Van
INSERT INTO MAP_NEAREST_TWN VALUES (200, 65);  --Burns Lake > Burns Lake
INSERT INTO MAP_NEAREST_TWN VALUES (294, 66);  --Burns Lake/Decker Lake > Burns Lake/Decker Lake
INSERT INTO MAP_NEAREST_TWN VALUES (267, 67);  --Burns Lake/Houston > Burns Lake/Houston
INSERT INTO MAP_NEAREST_TWN VALUES (285, 68);  --Burns Lake/Smithers > Burns Lake/Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (205, 69);  --Burns Lake/Telkwa/Prince George > Burns Lake/Telkwa/Prince George
INSERT INTO MAP_NEAREST_TWN VALUES (106, 70);  --Burton > Burton
INSERT INTO MAP_NEAREST_TWN VALUES (51, 71);  --Cache Creek > Cache Creek
INSERT INTO MAP_NEAREST_TWN VALUES (166, 72);  --Campbell River > Campbell River
INSERT INTO MAP_NEAREST_TWN VALUES (74, 73);  --Canal Flats > Canal Flats
INSERT INTO MAP_NEAREST_TWN VALUES (314, 74);  --Canim Lake > Canim Lake
INSERT INTO MAP_NEAREST_TWN VALUES (131, 75);  --Castlegar > Castlegar
INSERT INTO MAP_NEAREST_TWN VALUES (84, 76);  --Cecil Lake > Cecil Lake
INSERT INTO MAP_NEAREST_TWN VALUES (52, 77);  --Charlie Lake > Charlie Lake
INSERT INTO MAP_NEAREST_TWN VALUES (228, 78);  --Chase > Chase
INSERT INTO MAP_NEAREST_TWN VALUES (289, 79);  --Chase/Qualicum > Chase/Qualicum
INSERT INTO MAP_NEAREST_TWN VALUES (235, 80);  --Chemainus > Chemainus
INSERT INTO MAP_NEAREST_TWN VALUES (243, 81);  --Cherry Creek > Cherry Creek
INSERT INTO MAP_NEAREST_TWN VALUES (98, 82);  --Cherryville > Cherryville
INSERT INTO MAP_NEAREST_TWN VALUES (45, 83);  --Chetwynd > Chetwynd
INSERT INTO MAP_NEAREST_TWN VALUES (161, 84);  --Chetwynd/Hudson's Hope > Chetwynd/Hudson's Hope
INSERT INTO MAP_NEAREST_TWN VALUES (82, 85);  --Chilliwack > Chilliwack
INSERT INTO MAP_NEAREST_TWN VALUES (274, 86);  --Chilliwack/Hope > Chilliwack/Hope
INSERT INTO MAP_NEAREST_TWN VALUES (158, 87);  --Christina Lake > Christina Lake
INSERT INTO MAP_NEAREST_TWN VALUES (117, 88);  --Clearwater > Clearwater
INSERT INTO MAP_NEAREST_TWN VALUES (258, 89);  --Clearwater/Barriere > Clearwater/Barriere
INSERT INTO MAP_NEAREST_TWN VALUES (256, 90);  --Clearwater/Merritt > Clearwater/Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (54, 91);  --Clinton > Clinton
INSERT INTO MAP_NEAREST_TWN VALUES (206, 92);  --Cloverdale > Cloverdale
INSERT INTO MAP_NEAREST_TWN VALUES (97, 93);  --Coldstream > Coldstream
INSERT INTO MAP_NEAREST_TWN VALUES (183, 94);  --Comox > Comox
INSERT INTO MAP_NEAREST_TWN VALUES (244, 95);  --Coquitlam > Coquitlam
INSERT INTO MAP_NEAREST_TWN VALUES (242, 96);  --Coquitlam/Delta > Coquitlam/Delta
INSERT INTO MAP_NEAREST_TWN VALUES (181, 97);  --Courtenay > Courtenay
INSERT INTO MAP_NEAREST_TWN VALUES (187, 98);  --Cowichan 1 > Cowichan 1
INSERT INTO MAP_NEAREST_TWN VALUES (297, 99);  --Cowichan Bay > Cowichan Bay
INSERT INTO MAP_NEAREST_TWN VALUES (69, 100);  --Cranbrook > Cranbrook
INSERT INTO MAP_NEAREST_TWN VALUES (150, 101);  --Creston > Creston
INSERT INTO MAP_NEAREST_TWN VALUES (299, 102);  --Crofton > Crofton
INSERT INTO MAP_NEAREST_TWN VALUES (38, 103);  --Dawson Creek > Dawson Creek
INSERT INTO MAP_NEAREST_TWN VALUES (138, 104);  --Dease Lake > Dease Lake
INSERT INTO MAP_NEAREST_TWN VALUES (14, 105);  --Delta > Delta
INSERT INTO MAP_NEAREST_TWN VALUES (78, 106);  --Delta/New Westminster > Delta/New Westminster
INSERT INTO MAP_NEAREST_TWN VALUES (9, 107);  --Delta/Surrey > Delta/Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (88, 108);  --Deroche > Deroche
INSERT INTO MAP_NEAREST_TWN VALUES (229, 109);  --Donald > Donald
INSERT INTO MAP_NEAREST_TWN VALUES (227, 110);  --Duncan > Duncan
INSERT INTO MAP_NEAREST_TWN VALUES (247, 111);  --Edgewood > Edgewood
INSERT INTO MAP_NEAREST_TWN VALUES (152, 112);  --Elkford > Elkford
INSERT INTO MAP_NEAREST_TWN VALUES (154, 113);  --Elko > Elko
INSERT INTO MAP_NEAREST_TWN VALUES (34, 114);  --Enderby > Enderby
INSERT INTO MAP_NEAREST_TWN VALUES (282, 115);  --Esquimalt > Esquimalt
INSERT INTO MAP_NEAREST_TWN VALUES (76, 116);  --Fairmont > Fairmont
INSERT INTO MAP_NEAREST_TWN VALUES (254, 117);  --Fairmont Hot Springs > Fairmont Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (65, 118);  --Falkland > Falkland
INSERT INTO MAP_NEAREST_TWN VALUES (102, 119);  --Fauquier > Fauquier
INSERT INTO MAP_NEAREST_TWN VALUES (156, 120);  --Fernie > Fernie
INSERT INTO MAP_NEAREST_TWN VALUES (58, 121);  --Fort Nelson > Fort Nelson
INSERT INTO MAP_NEAREST_TWN VALUES (293, 122);  --Fort St John > Fort St John
INSERT INTO MAP_NEAREST_TWN VALUES (167, 123);  --Fort St. James > Fort St. James
INSERT INTO MAP_NEAREST_TWN VALUES (49, 124);  --Fort St. John > Fort St. John
INSERT INTO MAP_NEAREST_TWN VALUES (75, 125);  --Fort Steele > Fort Steele
INSERT INTO MAP_NEAREST_TWN VALUES (202, 126);  --Fraser Lake > Fraser Lake
INSERT INTO MAP_NEAREST_TWN VALUES (130, 127);  --Fruitvale > Fruitvale
INSERT INTO MAP_NEAREST_TWN VALUES (281, 128);  --Gabriola > Gabriola
INSERT INTO MAP_NEAREST_TWN VALUES (287, 129);  --Gabriola Island > Gabriola Island
INSERT INTO MAP_NEAREST_TWN VALUES (147, 130);  --Galena Bay > Galena Bay
INSERT INTO MAP_NEAREST_TWN VALUES (273, 131);  --Ganges > Ganges
INSERT INTO MAP_NEAREST_TWN VALUES (221, 132);  --Gibsons > Gibsons
INSERT INTO MAP_NEAREST_TWN VALUES (249, 133);  --Gold Bridge > Gold Bridge
INSERT INTO MAP_NEAREST_TWN VALUES (164, 134);  --Gold River > Gold River
INSERT INTO MAP_NEAREST_TWN VALUES (165, 135);  --Gold River/ Tahsis > Gold River/ Tahsis
INSERT INTO MAP_NEAREST_TWN VALUES (71, 136);  --Golden > Golden
INSERT INTO MAP_NEAREST_TWN VALUES (153, 137);  --Grand Forks > Grand Forks
INSERT INTO MAP_NEAREST_TWN VALUES (215, 138);  --Greenville > Greenville
INSERT INTO MAP_NEAREST_TWN VALUES (257, 139);  --Hagensborg > Hagensborg
INSERT INTO MAP_NEAREST_TWN VALUES (89, 140);  --Haig > Haig
INSERT INTO MAP_NEAREST_TWN VALUES (219, 141);  --Halfmoon Bay > Halfmoon Bay
INSERT INTO MAP_NEAREST_TWN VALUES (172, 142);  --Hanceville > Hanceville
INSERT INTO MAP_NEAREST_TWN VALUES (81, 143);  --Harrison / Kent > Harrison / Kent
INSERT INTO MAP_NEAREST_TWN VALUES (79, 144);  --Harrison Hot Springs > Harrison Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (72, 145);  --Harrogate > Harrogate
INSERT INTO MAP_NEAREST_TWN VALUES (204, 146);  --Hazelton > Hazelton
INSERT INTO MAP_NEAREST_TWN VALUES (151, 147);  --Hedley > Hedley
INSERT INTO MAP_NEAREST_TWN VALUES (120, 148);  --Heffley Creek > Heffley Creek
INSERT INTO MAP_NEAREST_TWN VALUES (63, 149);  --Hixon > Hixon
INSERT INTO MAP_NEAREST_TWN VALUES (303, 150);  --Holberg > Holberg
INSERT INTO MAP_NEAREST_TWN VALUES (119, 151);  --Hope > Hope
INSERT INTO MAP_NEAREST_TWN VALUES (159, 152);  --Hope/ Powell River > Hope/ Powell River
INSERT INTO MAP_NEAREST_TWN VALUES (310, 153);  --Horsefly > Horsefly
INSERT INTO MAP_NEAREST_TWN VALUES (315, 154);  --Hosmer > Hosmer
INSERT INTO MAP_NEAREST_TWN VALUES (198, 155);  --Houston > Houston
INSERT INTO MAP_NEAREST_TWN VALUES (163, 156);  --Hudson's Hope > Hudson's Hope
INSERT INTO MAP_NEAREST_TWN VALUES (225, 157);  --Invermere > Invermere
INSERT INTO MAP_NEAREST_TWN VALUES (66, 158);  --Kaleden > Kaleden
INSERT INTO MAP_NEAREST_TWN VALUES (64, 159);  --Kamloops > Kamloops
INSERT INTO MAP_NEAREST_TWN VALUES (107, 160);  --Kamloops/Merritt > Kamloops/Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (146, 161);  --Kaslo > Kaslo
INSERT INTO MAP_NEAREST_TWN VALUES (44, 162);  --Kelowna > Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (132, 163);  --Keremeos > Keremeos
INSERT INTO MAP_NEAREST_TWN VALUES (68, 164);  --Kimberley > Kimberley
INSERT INTO MAP_NEAREST_TWN VALUES (139, 165);  --Kitimat > Kitimat
INSERT INTO MAP_NEAREST_TWN VALUES (141, 166);  --Kitimat/Terrace > Kitimat/Terrace
INSERT INTO MAP_NEAREST_TWN VALUES (137, 167);  --Kitwanga > Kitwanga
INSERT INTO MAP_NEAREST_TWN VALUES (255, 168);  --Lac la Hache > Lac la Hache
INSERT INTO MAP_NEAREST_TWN VALUES (307, 169);  --Lake Country > Lake Country
INSERT INTO MAP_NEAREST_TWN VALUES (276, 170);  --Lake Cowichan > Lake Cowichan
INSERT INTO MAP_NEAREST_TWN VALUES (290, 171);  --Lake Cowichan and Sidney > Lake Cowichan and Sidney
INSERT INTO MAP_NEAREST_TWN VALUES (210, 172);  --Langford > Langford
INSERT INTO MAP_NEAREST_TWN VALUES (213, 173);  --Langley > Langley
INSERT INTO MAP_NEAREST_TWN VALUES (224, 174);  --Langley/ Maple Ridge > Langley/ Maple Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (271, 175);  --Likely > Likely
INSERT INTO MAP_NEAREST_TWN VALUES (8, 176);  --Lillooet > Lillooet
INSERT INTO MAP_NEAREST_TWN VALUES (26, 177);  --Lillooett > Lillooett
INSERT INTO MAP_NEAREST_TWN VALUES (20, 178);  --Lions Bay > Lions Bay
INSERT INTO MAP_NEAREST_TWN VALUES (110, 179);  --Little Fort > Little Fort
INSERT INTO MAP_NEAREST_TWN VALUES (27, 180);  --Logan Lake > Logan Lake
INSERT INTO MAP_NEAREST_TWN VALUES (169, 181);  --Lone Butte > Lone Butte
INSERT INTO MAP_NEAREST_TWN VALUES (100, 182);  --Lumby > Lumby
INSERT INTO MAP_NEAREST_TWN VALUES (214, 183);  --Lytton > Lytton
INSERT INTO MAP_NEAREST_TWN VALUES (56, 184);  --Mackenzie > Mackenzie
INSERT INTO MAP_NEAREST_TWN VALUES (86, 185);  --Maple Ridge > Maple Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (87, 186);  --Maple Ridge/Mission > Maple Ridge/Mission
INSERT INTO MAP_NEAREST_TWN VALUES (93, 187);  --Maple Ridge/Pitt Meadows > Maple Ridge/Pitt Meadows
INSERT INTO MAP_NEAREST_TWN VALUES (259, 188);  --Mara > Mara
INSERT INTO MAP_NEAREST_TWN VALUES (203, 189);  --Masset/Port Clements > Masset/Port Clements
INSERT INTO MAP_NEAREST_TWN VALUES (111, 190);  --McBride > McBride
INSERT INTO MAP_NEAREST_TWN VALUES (269, 191);  --McBride/Valemount > McBride/Valemount
INSERT INTO MAP_NEAREST_TWN VALUES (286, 192);  --McClure > McClure
INSERT INTO MAP_NEAREST_TWN VALUES (28, 193);  --Merritt > Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (29, 194);  --Merritt &Kelowna > Merritt & Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (241, 195);  --Mill Bay > Mill Bay
INSERT INTO MAP_NEAREST_TWN VALUES (231, 196);  --Mill Bay/Langford > Mill Bay/Langford
INSERT INTO MAP_NEAREST_TWN VALUES (264, 197);  --misc > misc
INSERT INTO MAP_NEAREST_TWN VALUES (90, 198);  --Mission > Mission
INSERT INTO MAP_NEAREST_TWN VALUES (216, 199);  --Mission/Abbotsford > Mission/Abbotsford
INSERT INTO MAP_NEAREST_TWN VALUES (59, 200);  --Monte Lake > Monte Lake
INSERT INTO MAP_NEAREST_TWN VALUES (129, 201);  --Montrose > Montrose
INSERT INTO MAP_NEAREST_TWN VALUES (25, 202);  --Mount Currie > Mount Currie
INSERT INTO MAP_NEAREST_TWN VALUES (142, 203);  --Moyie > Moyie
INSERT INTO MAP_NEAREST_TWN VALUES (2, 204);  --n/a > n/a
INSERT INTO MAP_NEAREST_TWN VALUES (105, 205);  --Nakusp > Nakusp
INSERT INTO MAP_NEAREST_TWN VALUES (178, 206);  --Nanaimo > Nanaimo
INSERT INTO MAP_NEAREST_TWN VALUES (186, 207);  --Nanaimo/ Courtenay > Nanaimo/ Courtenay
INSERT INTO MAP_NEAREST_TWN VALUES (180, 208);  --Nanoose Bay > Nanoose Bay
INSERT INTO MAP_NEAREST_TWN VALUES (313, 209);  --Naramata > Naramata
INSERT INTO MAP_NEAREST_TWN VALUES (1, 210);  --Nearest Town > Nearest Town
INSERT INTO MAP_NEAREST_TWN VALUES (101, 211);  --Nelson > Nelson
INSERT INTO MAP_NEAREST_TWN VALUES (252, 212);  --Nelson/Castlegar > Nelson/Castlegar
INSERT INTO MAP_NEAREST_TWN VALUES (308, 213);  --New Aiyansh > New Aiyansh
INSERT INTO MAP_NEAREST_TWN VALUES (145, 214);  --New Denver > New Denver
INSERT INTO MAP_NEAREST_TWN VALUES (280, 215);  --New Westminster > New Westminster
INSERT INTO MAP_NEAREST_TWN VALUES (77, 216);  --New Westminster/Surrey > New Westminster/Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (288, 217);  --North Van, Vancouver, Richmond > North Van, Vancouver, Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (19, 218);  --North Vancouver > North Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (50, 219);  --Okanagan Falls > Okanagan Falls
INSERT INTO MAP_NEAREST_TWN VALUES (57, 220);  --Oliver > Oliver
INSERT INTO MAP_NEAREST_TWN VALUES (133, 221);  --Ootischenia > Ootischenia
INSERT INTO MAP_NEAREST_TWN VALUES (67, 222);  --Osoyoos > Osoyoos
INSERT INTO MAP_NEAREST_TWN VALUES (41, 223);  --Oyama > Oyama
INSERT INTO MAP_NEAREST_TWN VALUES (250, 224);  --Panorama > Panorama
INSERT INTO MAP_NEAREST_TWN VALUES (122, 225);  --Parksville > Parksville
INSERT INTO MAP_NEAREST_TWN VALUES (30, 226);  --Peachland > Peachland
INSERT INTO MAP_NEAREST_TWN VALUES (10, 227);  --Pemberton > Pemberton
INSERT INTO MAP_NEAREST_TWN VALUES (222, 228);  --Pender Harbor > Pender Harbor
INSERT INTO MAP_NEAREST_TWN VALUES (53, 229);  --Penticton > Penticton
INSERT INTO MAP_NEAREST_TWN VALUES (92, 230);  --Pitt Meadows > Pitt Meadows
INSERT INTO MAP_NEAREST_TWN VALUES (123, 231);  --Port Alberni > Port Alberni
INSERT INTO MAP_NEAREST_TWN VALUES (148, 232);  --Port Alice > Port Alice
INSERT INTO MAP_NEAREST_TWN VALUES (85, 233);  --Port Coquitlam > Port Coquitlam
INSERT INTO MAP_NEAREST_TWN VALUES (184, 234);  --Port McNeill > Port Mcneill
INSERT INTO MAP_NEAREST_TWN VALUES (261, 234);  --Port McNeill > Port McNeill
INSERT INTO MAP_NEAREST_TWN VALUES (272, 235);  --Port Mellon > Port Mellon
INSERT INTO MAP_NEAREST_TWN VALUES (211, 236);  --Port Renfrew > Port Renfrew
INSERT INTO MAP_NEAREST_TWN VALUES (177, 237);  --Pouce Coupe > Pouce Coupe
INSERT INTO MAP_NEAREST_TWN VALUES (6, 238);  --Powell River > Powell River
INSERT INTO MAP_NEAREST_TWN VALUES (47, 239);  --Prince George > Prince George
INSERT INTO MAP_NEAREST_TWN VALUES (284, 240);  --Prince George/Fort St. James > Prince George/Fort St. James
INSERT INTO MAP_NEAREST_TWN VALUES (191, 241);  --Prince George/Smithers > Prince George/Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (292, 242);  --Prince Geroge > Prince Geroge
INSERT INTO MAP_NEAREST_TWN VALUES (192, 243);  --Prince Rupert > Prince Rupert
INSERT INTO MAP_NEAREST_TWN VALUES (109, 244);  --Princeton > Princeton
INSERT INTO MAP_NEAREST_TWN VALUES (251, 245);  --Pritchard > Pritchard
INSERT INTO MAP_NEAREST_TWN VALUES (266, 246);  --Quadra Island > Quadra Island
INSERT INTO MAP_NEAREST_TWN VALUES (278, 247);  --Qualicum > Qualicum
INSERT INTO MAP_NEAREST_TWN VALUES (196, 248);  --Queen Charlotte City > Queen Charlotte City
INSERT INTO MAP_NEAREST_TWN VALUES (42, 249);  --Quesnel > Quesnel
INSERT INTO MAP_NEAREST_TWN VALUES (108, 250);  --Quilchena > Quilchena
INSERT INTO MAP_NEAREST_TWN VALUES (70, 251);  --Radium Hot Springs > Radium Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (170, 252);  --Revelstoke > Revelstoke
INSERT INTO MAP_NEAREST_TWN VALUES (236, 253);  --Revelstoke/Golden > Revelstoke/Golden
INSERT INTO MAP_NEAREST_TWN VALUES (13, 254);  --Richmond > Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (15, 255);  --Richmond/Delta > Richmond/Delta
INSERT INTO MAP_NEAREST_TWN VALUES (175, 256);  --Riske Creek > Riske Creek
INSERT INTO MAP_NEAREST_TWN VALUES (220, 257);  --Roberts Creek > Roberts Creek
INSERT INTO MAP_NEAREST_TWN VALUES (143, 258);  --Rock Creek > Rock Creek
INSERT INTO MAP_NEAREST_TWN VALUES (194, 259);  --Rose Lake > Rose Lake
INSERT INTO MAP_NEAREST_TWN VALUES (128, 260);  --Rossland > Rossland
INSERT INTO MAP_NEAREST_TWN VALUES (91, 261);  --Ruskin > Ruskin
INSERT INTO MAP_NEAREST_TWN VALUES (260, 262);  --Rutland > Rutland
INSERT INTO MAP_NEAREST_TWN VALUES (188, 263);  --Saanich > Saanich
INSERT INTO MAP_NEAREST_TWN VALUES (301, 264);  --Saanich/Duncan > Saanich/Duncan
INSERT INTO MAP_NEAREST_TWN VALUES (104, 265);  --Salmo > Salmo
INSERT INTO MAP_NEAREST_TWN VALUES (31, 266);  --Salmon Arm > Salmon Arm
INSERT INTO MAP_NEAREST_TWN VALUES (302, 267);  --Savary Island > Savary Island
INSERT INTO MAP_NEAREST_TWN VALUES (239, 268);  --Savona > Savona
INSERT INTO MAP_NEAREST_TWN VALUES (182, 269);  --Sayward > Sayward
INSERT INTO MAP_NEAREST_TWN VALUES (218, 270);  --Sechelt > Sechelt
INSERT INTO MAP_NEAREST_TWN VALUES (246, 271);  --Seton Portage > Seton Portage
INSERT INTO MAP_NEAREST_TWN VALUES (234, 272);  --Shawnigan Lake > Shawnigan Lake
INSERT INTO MAP_NEAREST_TWN VALUES (32, 273);  --Sicamous > Sicamous
INSERT INTO MAP_NEAREST_TWN VALUES (189, 274);  --Sidney > Sidney
INSERT INTO MAP_NEAREST_TWN VALUES (96, 275);  --Silverton > Silverton
INSERT INTO MAP_NEAREST_TWN VALUES (73, 276);  --Skookumchuck > Skookumchuck
INSERT INTO MAP_NEAREST_TWN VALUES (99, 277);  --Slocan > Slocan
INSERT INTO MAP_NEAREST_TWN VALUES (199, 278);  --Smithers > Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (209, 279);  --Sooke > Sooke
INSERT INTO MAP_NEAREST_TWN VALUES (226, 280);  --Sorrento > Sorrento
INSERT INTO MAP_NEAREST_TWN VALUES (94, 281);  --South Slocan > South Slocan
INSERT INTO MAP_NEAREST_TWN VALUES (35, 282);  --Spallumcheen > Spallumcheen
INSERT INTO MAP_NEAREST_TWN VALUES (149, 283);  --Sparwood > Sparwood
INSERT INTO MAP_NEAREST_TWN VALUES (83, 284);  --Spences Bridge > Spences Bridge
INSERT INTO MAP_NEAREST_TWN VALUES (232, 285);  --Spuzzum > Spuzzum
INSERT INTO MAP_NEAREST_TWN VALUES (17, 286);  --Squamish > Squamish
INSERT INTO MAP_NEAREST_TWN VALUES (245, 287);  --Squilax > Squilax
INSERT INTO MAP_NEAREST_TWN VALUES (136, 288);  --Stewart > Stewart
INSERT INTO MAP_NEAREST_TWN VALUES (291, 289);  --Stewrt > Stewrt
INSERT INTO MAP_NEAREST_TWN VALUES (60, 290);  --Summerland > Summerland
INSERT INTO MAP_NEAREST_TWN VALUES (12, 291);  --Surrey > Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (208, 291);  --Surrey > Surrey  
INSERT INTO MAP_NEAREST_TWN VALUES (265, 292);  --Surrey, Langley > Surrey, Langley
INSERT INTO MAP_NEAREST_TWN VALUES (207, 293);  --Surrey/Cloverdale > Surrey/Cloverdale
INSERT INTO MAP_NEAREST_TWN VALUES (223, 294);  --Surrey/Richmond > Surrey/Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (306, 295);  --Tahsis > Tahsis
INSERT INTO MAP_NEAREST_TWN VALUES (230, 296);  --Tappen > Tappen
INSERT INTO MAP_NEAREST_TWN VALUES (173, 297);  --Tatla Lake > Tatla Lake
INSERT INTO MAP_NEAREST_TWN VALUES (39, 298);  --Taylor > Taylor
INSERT INTO MAP_NEAREST_TWN VALUES (140, 299);  --Telkwa > Telkwa
INSERT INTO MAP_NEAREST_TWN VALUES (4, 300);  --Terrace > Terrace
INSERT INTO MAP_NEAREST_TWN VALUES (268, 302);  --Tlell > Tlell
INSERT INTO MAP_NEAREST_TWN VALUES (124, 303);  --Tofino > Tofino
INSERT INTO MAP_NEAREST_TWN VALUES (195, 304);  --Topley > Topley
INSERT INTO MAP_NEAREST_TWN VALUES (126, 305);  --Trail > Trail
INSERT INTO MAP_NEAREST_TWN VALUES (157, 306);  --Trail/Rossland > Trail/Rossland
INSERT INTO MAP_NEAREST_TWN VALUES (197, 301);  --Tte Jaune Cache > Tête Jaune Cache
INSERT INTO MAP_NEAREST_TWN VALUES (162, 307);  --Tumbler Ridge > Tumbler Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (125, 308);  --Ucluelet > Ucluelet
INSERT INTO MAP_NEAREST_TWN VALUES (185, 309);  --Union Bay > Union Bay
INSERT INTO MAP_NEAREST_TWN VALUES (304, 310);  --Unknown > Unknown
INSERT INTO MAP_NEAREST_TWN VALUES (115, 311);  --Valemount > Valemount
INSERT INTO MAP_NEAREST_TWN VALUES (116, 312);  --Valemount/Blue River > Valemount/Blue River
INSERT INTO MAP_NEAREST_TWN VALUES (112, 313);  --Valmount > Valmount
INSERT INTO MAP_NEAREST_TWN VALUES (11, 314);  --Vancouver > Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (263, 314);  --Vancouver > Vancouver  
INSERT INTO MAP_NEAREST_TWN VALUES (262, 315);  --Vancouver/Richmond > Vancouver/Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (24, 316);  --Vancouver/West Vancouver > Vancouver/West Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (22, 317);  --Vancouver/Whistler > Vancouver/Whistler
INSERT INTO MAP_NEAREST_TWN VALUES (201, 318);  --Vanderhoof > Vanderhoof
INSERT INTO MAP_NEAREST_TWN VALUES (270, 319);  --Vanderhoof/Fraser Lake/Fort St James > Vanderhoof/Fraser Lake/Fort St James
INSERT INTO MAP_NEAREST_TWN VALUES (5, 320);  --Various > various
INSERT INTO MAP_NEAREST_TWN VALUES (37, 320);  --Various > Various
INSERT INTO MAP_NEAREST_TWN VALUES (114, 321);  --Vavenby > Vavenby
INSERT INTO MAP_NEAREST_TWN VALUES (48, 322);  --Vernon > Vernon
INSERT INTO MAP_NEAREST_TWN VALUES (190, 323);  --Victoria > Victoria
INSERT INTO MAP_NEAREST_TWN VALUES (295, 324);  --View Royal > View Royal
INSERT INTO MAP_NEAREST_TWN VALUES (275, 325);  --Walhachin > Walhachin
INSERT INTO MAP_NEAREST_TWN VALUES (160, 326);  --Wardner > Wardner
INSERT INTO MAP_NEAREST_TWN VALUES (127, 327);  --Warfield > Warfield
INSERT INTO MAP_NEAREST_TWN VALUES (36, 328);  --West Kelowna > West Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (62, 329);  --West Kelowna/Kelowna > West Kelowna/Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (16, 330);  --West Vancouver > West Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (61, 331);  --Westbank > Westbank
INSERT INTO MAP_NEAREST_TWN VALUES (253, 332);  --Westwold > Westwold
INSERT INTO MAP_NEAREST_TWN VALUES (7, 333);  --Whistler > Whistler
INSERT INTO MAP_NEAREST_TWN VALUES (18, 334);  --Whistler/Pemberton > Whistler/Pemberton
INSERT INTO MAP_NEAREST_TWN VALUES (46, 335);  --williams Lake > Williams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (55, 335);  --williams Lake > williams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (311, 336);  --Windermere > Windermere
INSERT INTO MAP_NEAREST_TWN VALUES (95, 337);  --Winlaw > Winlaw
INSERT INTO MAP_NEAREST_TWN VALUES (193, 338);  --Witset > Witset
INSERT INTO MAP_NEAREST_TWN VALUES (179, 339);  --Woss > Woss
INSERT INTO MAP_NEAREST_TWN VALUES (155, 340);  --Yahk > Yahk
INSERT INTO MAP_NEAREST_TWN VALUES (238, 341);  --Yale > Yale
INSERT INTO MAP_NEAREST_TWN VALUES (103, 342);  --Ymir > Ymir
INSERT INTO MAP_NEAREST_TWN VALUES (277, 343);  --Youbou > Youbou
INSERT INTO MAP_NEAREST_TWN VALUES (296, 344);  --Zeballos > Zeballos

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblTowns

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'NEARST_TWN'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_NEAREST_TWN

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_NEAREST_TWN

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjects tp
	JOIN tblTowns town
	ON town.ID = tp.[Nearest Town]
	WHERE [Nearest Town] IN (SELECT ID FROM 
		(SELECT * FROM MAP_NEAREST_TWN mnt
		RIGHT JOIN tblTowns tt
		ON tt.ID = mnt.LEGACY_ID) AS NearestTown
		WHERE LEGACY_ID IS NULL)
	AND [Town Name] IS NOT NULL

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Projects linked to un-mapped Nearest Town'
END

/*
-- should be zero, as we filtered out those with NULL town name

SELECT town.ID, town.[Town Name], tp.*
FROM tblProjects tp
JOIN tblTowns town
ON town.ID = tp.[Nearest Town]
WHERE [Nearest Town] IN (SELECT ID FROM 
	(SELECT * FROM MAP_NEAREST_TWN mnt
	RIGHT JOIN tblTowns tt
	ON tt.ID = mnt.LEGACY_ID) AS NearestTown
	WHERE LEGACY_ID IS NULL)
AND [Town Name] IS NOT NULL
*/

