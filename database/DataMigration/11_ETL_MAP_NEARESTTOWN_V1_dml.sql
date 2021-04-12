/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT ID, [Town Name] 
FROM tblTowns
WHERE ID NOT IN (3, 121)
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

/*** Generated Inserts Go Here ***/
INSERT INTO MAP_NEAREST_TWN VALUES (23, 381);  --100 Mile House > 100 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (309, 382);  --150 Mile House > 150 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (40, 383);  --70 Mile > 70 Mile
INSERT INTO MAP_NEAREST_TWN VALUES (43, 384);  --70 Mile House > 70 Mile House
INSERT INTO MAP_NEAREST_TWN VALUES (217, 385);  --Abbotsford > Abbotsford
INSERT INTO MAP_NEAREST_TWN VALUES (312, 386);  --Adams Lake > Adams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (80, 387);  --Agassiz > Agassiz
INSERT INTO MAP_NEAREST_TWN VALUES (212, 388);  --Aldergrove > Aldergrove
INSERT INTO MAP_NEAREST_TWN VALUES (176, 389);  --Alexis Creek > Alexis Creek
INSERT INTO MAP_NEAREST_TWN VALUES (171, 390);  --Anahim Lake > Anahim Lake
INSERT INTO MAP_NEAREST_TWN VALUES (33, 391);  --Armstrong > Armstrong
INSERT INTO MAP_NEAREST_TWN VALUES (233, 392);  --Ashcroft > Ashcroft
INSERT INTO MAP_NEAREST_TWN VALUES (283, 393);  --Atlin > Atlin
INSERT INTO MAP_NEAREST_TWN VALUES (134, 394);  --Balfour > Balfour
INSERT INTO MAP_NEAREST_TWN VALUES (279, 395);  --Bamfield > Bamfield
INSERT INTO MAP_NEAREST_TWN VALUES (168, 396);  --Barkerville > Barkerville
INSERT INTO MAP_NEAREST_TWN VALUES (118, 397);  --Barriere > Barriere
INSERT INTO MAP_NEAREST_TWN VALUES (144, 398);  --Beaverdell > Beaverdell
INSERT INTO MAP_NEAREST_TWN VALUES (174, 399);  --Bella Coola > Bella Coola
INSERT INTO MAP_NEAREST_TWN VALUES (237, 400);  --Blaeberry > Blaeberry
INSERT INTO MAP_NEAREST_TWN VALUES (298, 401);  --Blind Bay > Blind Bay
INSERT INTO MAP_NEAREST_TWN VALUES (113, 402);  --Blue River > Blue River
INSERT INTO MAP_NEAREST_TWN VALUES (240, 403);  --Boston Bar > Boston Bar
INSERT INTO MAP_NEAREST_TWN VALUES (135, 404);  --Boswell > Boswell
INSERT INTO MAP_NEAREST_TWN VALUES (305, 405);  --Bowser > Bowser
INSERT INTO MAP_NEAREST_TWN VALUES (248, 406);  --Bridge Lake > Bridge Lake
INSERT INTO MAP_NEAREST_TWN VALUES (21, 407);  --Britannia Beach > Britannia Beach
INSERT INTO MAP_NEAREST_TWN VALUES (300, 408);  --Burnaby, Delta, West Van > Burnaby, Delta, West Van
INSERT INTO MAP_NEAREST_TWN VALUES (200, 409);  --Burns Lake > Burns Lake
INSERT INTO MAP_NEAREST_TWN VALUES (294, 410);  --Burns Lake/Decker Lake > Burns Lake/Decker Lake
INSERT INTO MAP_NEAREST_TWN VALUES (267, 411);  --Burns Lake/Houston > Burns Lake/Houston
INSERT INTO MAP_NEAREST_TWN VALUES (285, 412);  --Burns Lake/Smithers > Burns Lake/Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (205, 413);  --Burns Lake/Telkwa/Prince George > Burns Lake/Telkwa/Prince George
INSERT INTO MAP_NEAREST_TWN VALUES (106, 414);  --Burton > Burton
INSERT INTO MAP_NEAREST_TWN VALUES (51, 415);  --Cache Creek > Cache Creek
INSERT INTO MAP_NEAREST_TWN VALUES (166, 416);  --Campbell River > Campbell River
INSERT INTO MAP_NEAREST_TWN VALUES (74, 417);  --Canal Flats > Canal Flats
INSERT INTO MAP_NEAREST_TWN VALUES (314, 418);  --Canim Lake > Canim Lake
INSERT INTO MAP_NEAREST_TWN VALUES (131, 419);  --Castlegar > Castlegar
INSERT INTO MAP_NEAREST_TWN VALUES (84, 420);  --Cecil Lake > Cecil Lake
INSERT INTO MAP_NEAREST_TWN VALUES (52, 421);  --Charlie Lake > Charlie Lake
INSERT INTO MAP_NEAREST_TWN VALUES (228, 422);  --Chase > Chase
INSERT INTO MAP_NEAREST_TWN VALUES (289, 423);  --Chase/Qualicum > Chase/Qualicum
INSERT INTO MAP_NEAREST_TWN VALUES (235, 424);  --Chemainus > Chemainus
INSERT INTO MAP_NEAREST_TWN VALUES (243, 425);  --Cherry Creek > Cherry Creek
INSERT INTO MAP_NEAREST_TWN VALUES (98, 426);  --Cherryville > Cherryville
INSERT INTO MAP_NEAREST_TWN VALUES (45, 427);  --Chetwynd > Chetwynd
INSERT INTO MAP_NEAREST_TWN VALUES (161, 428);  --Chetwynd/Hudson's Hope > Chetwynd/Hudson's Hope
INSERT INTO MAP_NEAREST_TWN VALUES (82, 429);  --Chilliwack > Chilliwack
INSERT INTO MAP_NEAREST_TWN VALUES (274, 430);  --Chilliwack/Hope > Chilliwack/Hope
INSERT INTO MAP_NEAREST_TWN VALUES (158, 431);  --Christina Lake > Christina Lake
INSERT INTO MAP_NEAREST_TWN VALUES (117, 432);  --Clearwater > Clearwater
INSERT INTO MAP_NEAREST_TWN VALUES (258, 433);  --Clearwater/Barriere > Clearwater/Barriere
INSERT INTO MAP_NEAREST_TWN VALUES (256, 434);  --Clearwater/Merritt > Clearwater/Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (54, 435);  --Clinton > Clinton
INSERT INTO MAP_NEAREST_TWN VALUES (206, 436);  --Cloverdale > Cloverdale
INSERT INTO MAP_NEAREST_TWN VALUES (97, 437);  --Coldstream > Coldstream
INSERT INTO MAP_NEAREST_TWN VALUES (183, 438);  --Comox > Comox
INSERT INTO MAP_NEAREST_TWN VALUES (244, 439);  --Coquitlam > Coquitlam
INSERT INTO MAP_NEAREST_TWN VALUES (242, 440);  --Coquitlam/Delta > Coquitlam/Delta
INSERT INTO MAP_NEAREST_TWN VALUES (181, 441);  --Courtenay > Courtenay
INSERT INTO MAP_NEAREST_TWN VALUES (187, 442);  --Cowichan 1 > Cowichan 1
INSERT INTO MAP_NEAREST_TWN VALUES (297, 443);  --Cowichan Bay > Cowichan Bay
INSERT INTO MAP_NEAREST_TWN VALUES (69, 444);  --Cranbrook > Cranbrook
INSERT INTO MAP_NEAREST_TWN VALUES (150, 445);  --Creston > Creston
INSERT INTO MAP_NEAREST_TWN VALUES (299, 446);  --Crofton > Crofton
INSERT INTO MAP_NEAREST_TWN VALUES (38, 447);  --Dawson Creek > Dawson Creek
INSERT INTO MAP_NEAREST_TWN VALUES (138, 448);  --Dease Lake > Dease Lake
INSERT INTO MAP_NEAREST_TWN VALUES (14, 449);  --Delta > Delta
INSERT INTO MAP_NEAREST_TWN VALUES (78, 450);  --Delta/New Westminster > Delta/New Westminster
INSERT INTO MAP_NEAREST_TWN VALUES (9, 451);  --Delta/Surrey > Delta/Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (88, 452);  --Deroche > Deroche
INSERT INTO MAP_NEAREST_TWN VALUES (229, 453);  --Donald > Donald
INSERT INTO MAP_NEAREST_TWN VALUES (227, 454);  --Duncan > Duncan
INSERT INTO MAP_NEAREST_TWN VALUES (247, 455);  --Edgewood > Edgewood
INSERT INTO MAP_NEAREST_TWN VALUES (152, 456);  --Elkford > Elkford
INSERT INTO MAP_NEAREST_TWN VALUES (154, 457);  --Elko > Elko
INSERT INTO MAP_NEAREST_TWN VALUES (34, 458);  --Enderby > Enderby
INSERT INTO MAP_NEAREST_TWN VALUES (282, 459);  --Esquimalt > Esquimalt
INSERT INTO MAP_NEAREST_TWN VALUES (76, 460);  --Fairmont > Fairmont
INSERT INTO MAP_NEAREST_TWN VALUES (254, 461);  --Fairmont Hot Springs > Fairmont Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (65, 462);  --Falkland > Falkland
INSERT INTO MAP_NEAREST_TWN VALUES (102, 463);  --Fauquier > Fauquier
INSERT INTO MAP_NEAREST_TWN VALUES (156, 464);  --Fernie > Fernie
INSERT INTO MAP_NEAREST_TWN VALUES (58, 465);  --Fort Nelson > Fort Nelson
INSERT INTO MAP_NEAREST_TWN VALUES (293, 466);  --Fort St John > Fort St John
INSERT INTO MAP_NEAREST_TWN VALUES (167, 467);  --Fort St. James > Fort St. James
INSERT INTO MAP_NEAREST_TWN VALUES (49, 468);  --Fort St. John > Fort St. John
INSERT INTO MAP_NEAREST_TWN VALUES (75, 469);  --Fort Steele > Fort Steele
INSERT INTO MAP_NEAREST_TWN VALUES (202, 470);  --Fraser Lake > Fraser Lake
INSERT INTO MAP_NEAREST_TWN VALUES (130, 471);  --Fruitvale > Fruitvale
INSERT INTO MAP_NEAREST_TWN VALUES (281, 472);  --Gabriola > Gabriola
INSERT INTO MAP_NEAREST_TWN VALUES (287, 473);  --Gabriola Island > Gabriola Island
INSERT INTO MAP_NEAREST_TWN VALUES (147, 474);  --Galena Bay > Galena Bay
INSERT INTO MAP_NEAREST_TWN VALUES (273, 475);  --Ganges > Ganges
INSERT INTO MAP_NEAREST_TWN VALUES (221, 476);  --Gibsons > Gibsons
INSERT INTO MAP_NEAREST_TWN VALUES (249, 477);  --Gold Bridge > Gold Bridge
INSERT INTO MAP_NEAREST_TWN VALUES (164, 478);  --Gold River > Gold River
INSERT INTO MAP_NEAREST_TWN VALUES (165, 479);  --Gold River/ Tahsis > Gold River/ Tahsis
INSERT INTO MAP_NEAREST_TWN VALUES (71, 480);  --Golden > Golden
INSERT INTO MAP_NEAREST_TWN VALUES (153, 481);  --Grand Forks > Grand Forks
INSERT INTO MAP_NEAREST_TWN VALUES (215, 482);  --Greenville > Greenville
INSERT INTO MAP_NEAREST_TWN VALUES (257, 483);  --Hagensborg > Hagensborg
INSERT INTO MAP_NEAREST_TWN VALUES (89, 484);  --Haig > Haig
INSERT INTO MAP_NEAREST_TWN VALUES (219, 485);  --Halfmoon Bay > Halfmoon Bay
INSERT INTO MAP_NEAREST_TWN VALUES (172, 486);  --Hanceville > Hanceville
INSERT INTO MAP_NEAREST_TWN VALUES (81, 487);  --Harrison / Kent > Harrison / Kent
INSERT INTO MAP_NEAREST_TWN VALUES (79, 488);  --Harrison Hot Springs > Harrison Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (72, 489);  --Harrogate > Harrogate
INSERT INTO MAP_NEAREST_TWN VALUES (204, 490);  --Hazelton > Hazelton
INSERT INTO MAP_NEAREST_TWN VALUES (151, 491);  --Hedley > Hedley
INSERT INTO MAP_NEAREST_TWN VALUES (120, 492);  --Heffley Creek > Heffley Creek
INSERT INTO MAP_NEAREST_TWN VALUES (63, 493);  --Hixon > Hixon
INSERT INTO MAP_NEAREST_TWN VALUES (303, 494);  --Holberg > Holberg
INSERT INTO MAP_NEAREST_TWN VALUES (119, 495);  --Hope > Hope
INSERT INTO MAP_NEAREST_TWN VALUES (159, 496);  --Hope/ Powell River > Hope/ Powell River
INSERT INTO MAP_NEAREST_TWN VALUES (310, 497);  --Horsefly > Horsefly
INSERT INTO MAP_NEAREST_TWN VALUES (315, 498);  --Hosmer > Hosmer
INSERT INTO MAP_NEAREST_TWN VALUES (198, 499);  --Houston > Houston
INSERT INTO MAP_NEAREST_TWN VALUES (163, 500);  --Hudson's Hope > Hudson's Hope
INSERT INTO MAP_NEAREST_TWN VALUES (225, 501);  --Invermere > Invermere
INSERT INTO MAP_NEAREST_TWN VALUES (66, 502);  --Kaleden > Kaleden
INSERT INTO MAP_NEAREST_TWN VALUES (64, 503);  --Kamloops > Kamloops
INSERT INTO MAP_NEAREST_TWN VALUES (107, 504);  --Kamloops/Merritt > Kamloops/Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (146, 505);  --Kaslo > Kaslo
INSERT INTO MAP_NEAREST_TWN VALUES (44, 506);  --Kelowna > Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (132, 507);  --Keremeos > Keremeos
INSERT INTO MAP_NEAREST_TWN VALUES (68, 508);  --Kimberley > Kimberley
INSERT INTO MAP_NEAREST_TWN VALUES (139, 509);  --Kitimat > Kitimat
INSERT INTO MAP_NEAREST_TWN VALUES (141, 510);  --Kitimat/Terrace > Kitimat/Terrace
INSERT INTO MAP_NEAREST_TWN VALUES (137, 511);  --Kitwanga > Kitwanga
INSERT INTO MAP_NEAREST_TWN VALUES (255, 512);  --Lac la Hache > Lac la Hache
INSERT INTO MAP_NEAREST_TWN VALUES (307, 513);  --Lake Country > Lake Country
INSERT INTO MAP_NEAREST_TWN VALUES (276, 514);  --Lake Cowichan > Lake Cowichan
INSERT INTO MAP_NEAREST_TWN VALUES (290, 515);  --Lake Cowichan and Sidney > Lake Cowichan and Sidney
INSERT INTO MAP_NEAREST_TWN VALUES (210, 516);  --Langford > Langford
INSERT INTO MAP_NEAREST_TWN VALUES (213, 517);  --Langley > Langley
INSERT INTO MAP_NEAREST_TWN VALUES (224, 518);  --Langley/ Maple Ridge > Langley/ Maple Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (271, 519);  --Likely > Likely
INSERT INTO MAP_NEAREST_TWN VALUES (8, 520);  --Lillooet > Lillooet
INSERT INTO MAP_NEAREST_TWN VALUES (26, 521);  --Lillooett > Lillooett
INSERT INTO MAP_NEAREST_TWN VALUES (20, 522);  --Lions Bay > Lions Bay
INSERT INTO MAP_NEAREST_TWN VALUES (110, 523);  --Little Fort > Little Fort
INSERT INTO MAP_NEAREST_TWN VALUES (27, 524);  --Logan Lake > Logan Lake
INSERT INTO MAP_NEAREST_TWN VALUES (169, 525);  --Lone Butte > Lone Butte
INSERT INTO MAP_NEAREST_TWN VALUES (100, 526);  --Lumby > Lumby
INSERT INTO MAP_NEAREST_TWN VALUES (214, 527);  --Lytton > Lytton
INSERT INTO MAP_NEAREST_TWN VALUES (56, 528);  --Mackenzie > Mackenzie
INSERT INTO MAP_NEAREST_TWN VALUES (86, 529);  --Maple Ridge > Maple Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (87, 530);  --Maple Ridge/Mission > Maple Ridge/Mission
INSERT INTO MAP_NEAREST_TWN VALUES (93, 531);  --Maple Ridge/Pitt Meadows > Maple Ridge/Pitt Meadows
INSERT INTO MAP_NEAREST_TWN VALUES (259, 532);  --Mara > Mara
INSERT INTO MAP_NEAREST_TWN VALUES (203, 533);  --Masset/Port Clements > Masset/Port Clements
INSERT INTO MAP_NEAREST_TWN VALUES (111, 534);  --McBride > McBride
INSERT INTO MAP_NEAREST_TWN VALUES (269, 535);  --McBride/Valemount > McBride/Valemount
INSERT INTO MAP_NEAREST_TWN VALUES (286, 536);  --McClure > McClure
INSERT INTO MAP_NEAREST_TWN VALUES (28, 537);  --Merritt > Merritt
INSERT INTO MAP_NEAREST_TWN VALUES (29, 538);  --Merritt &Kelowna > Merritt & Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (241, 539);  --Mill Bay > Mill Bay
INSERT INTO MAP_NEAREST_TWN VALUES (231, 540);  --Mill Bay/Langford > Mill Bay/Langford
INSERT INTO MAP_NEAREST_TWN VALUES (264, 541);  --misc > misc
INSERT INTO MAP_NEAREST_TWN VALUES (90, 542);  --Mission > Mission
INSERT INTO MAP_NEAREST_TWN VALUES (216, 543);  --Mission/Abbotsford > Mission/Abbotsford
INSERT INTO MAP_NEAREST_TWN VALUES (59, 544);  --Monte Lake > Monte Lake
INSERT INTO MAP_NEAREST_TWN VALUES (129, 545);  --Montrose > Montrose
INSERT INTO MAP_NEAREST_TWN VALUES (25, 546);  --Mount Currie > Mount Currie
INSERT INTO MAP_NEAREST_TWN VALUES (142, 547);  --Moyie > Moyie
INSERT INTO MAP_NEAREST_TWN VALUES (2, 548);  --n/a > n/a
INSERT INTO MAP_NEAREST_TWN VALUES (105, 549);  --Nakusp > Nakusp
INSERT INTO MAP_NEAREST_TWN VALUES (178, 550);  --Nanaimo > Nanaimo
INSERT INTO MAP_NEAREST_TWN VALUES (186, 551);  --Nanaimo/ Courtenay > Nanaimo/ Courtenay
INSERT INTO MAP_NEAREST_TWN VALUES (180, 552);  --Nanoose Bay > Nanoose Bay
INSERT INTO MAP_NEAREST_TWN VALUES (313, 553);  --Naramata > Naramata
INSERT INTO MAP_NEAREST_TWN VALUES (1, 554);  --Nearest Town > Nearest Town
INSERT INTO MAP_NEAREST_TWN VALUES (101, 555);  --Nelson > Nelson
INSERT INTO MAP_NEAREST_TWN VALUES (252, 556);  --Nelson/Castlegar > Nelson/Castlegar
INSERT INTO MAP_NEAREST_TWN VALUES (308, 557);  --New Aiyansh > New Aiyansh
INSERT INTO MAP_NEAREST_TWN VALUES (145, 558);  --New Denver > New Denver
INSERT INTO MAP_NEAREST_TWN VALUES (280, 559);  --New Westminster > New Westminster
INSERT INTO MAP_NEAREST_TWN VALUES (77, 560);  --New Westminster/Surrey > New Westminster/Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (288, 561);  --North Van, Vancouver, Richmond > North Van, Vancouver, Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (19, 562);  --North Vancouver > North Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (50, 563);  --Okanagan Falls > Okanagan Falls
INSERT INTO MAP_NEAREST_TWN VALUES (57, 564);  --Oliver > Oliver
INSERT INTO MAP_NEAREST_TWN VALUES (133, 565);  --Ootischenia > Ootischenia
INSERT INTO MAP_NEAREST_TWN VALUES (67, 566);  --Osoyoos > Osoyoos
INSERT INTO MAP_NEAREST_TWN VALUES (41, 567);  --Oyama > Oyama
INSERT INTO MAP_NEAREST_TWN VALUES (250, 568);  --Panorama > Panorama
INSERT INTO MAP_NEAREST_TWN VALUES (122, 569);  --Parksville > Parksville
INSERT INTO MAP_NEAREST_TWN VALUES (30, 570);  --Peachland > Peachland
INSERT INTO MAP_NEAREST_TWN VALUES (10, 571);  --Pemberton > Pemberton
INSERT INTO MAP_NEAREST_TWN VALUES (222, 572);  --Pender Harbor > Pender Harbor
INSERT INTO MAP_NEAREST_TWN VALUES (53, 573);  --Penticton > Penticton
INSERT INTO MAP_NEAREST_TWN VALUES (92, 574);  --Pitt Meadows > Pitt Meadows
INSERT INTO MAP_NEAREST_TWN VALUES (123, 575);  --Port Alberni > Port Alberni
INSERT INTO MAP_NEAREST_TWN VALUES (148, 576);  --Port Alice > Port Alice
INSERT INTO MAP_NEAREST_TWN VALUES (85, 577);  --Port Coquitlam > Port Coquitlam
INSERT INTO MAP_NEAREST_TWN VALUES (261, 578);  --Port McNeill > Port McNeill
INSERT INTO MAP_NEAREST_TWN VALUES (184, 578);  --Port McNeill > Port Mcneill
INSERT INTO MAP_NEAREST_TWN VALUES (272, 579);  --Port Mellon > Port Mellon
INSERT INTO MAP_NEAREST_TWN VALUES (211, 580);  --Port Renfrew > Port Renfrew
INSERT INTO MAP_NEAREST_TWN VALUES (177, 581);  --Pouce Coupe > Pouce Coupe
INSERT INTO MAP_NEAREST_TWN VALUES (6, 582);  --Powell River > Powell River
INSERT INTO MAP_NEAREST_TWN VALUES (47, 583);  --Prince George > Prince George
INSERT INTO MAP_NEAREST_TWN VALUES (284, 584);  --Prince George/Fort St. James > Prince George/Fort St. James
INSERT INTO MAP_NEAREST_TWN VALUES (191, 585);  --Prince George/Smithers > Prince George/Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (292, 586);  --Prince Geroge > Prince Geroge
INSERT INTO MAP_NEAREST_TWN VALUES (192, 587);  --Prince Rupert > Prince Rupert
INSERT INTO MAP_NEAREST_TWN VALUES (109, 588);  --Princeton > Princeton
INSERT INTO MAP_NEAREST_TWN VALUES (251, 589);  --Pritchard > Pritchard
INSERT INTO MAP_NEAREST_TWN VALUES (266, 590);  --Quadra Island > Quadra Island
INSERT INTO MAP_NEAREST_TWN VALUES (278, 591);  --Qualicum > Qualicum
INSERT INTO MAP_NEAREST_TWN VALUES (196, 592);  --Queen Charlotte City > Queen Charlotte City
INSERT INTO MAP_NEAREST_TWN VALUES (42, 593);  --Quesnel > Quesnel
INSERT INTO MAP_NEAREST_TWN VALUES (108, 594);  --Quilchena > Quilchena
INSERT INTO MAP_NEAREST_TWN VALUES (70, 595);  --Radium Hot Springs > Radium Hot Springs
INSERT INTO MAP_NEAREST_TWN VALUES (170, 596);  --Revelstoke > Revelstoke
INSERT INTO MAP_NEAREST_TWN VALUES (236, 597);  --Revelstoke/Golden > Revelstoke/Golden
INSERT INTO MAP_NEAREST_TWN VALUES (13, 598);  --Richmond > Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (15, 599);  --Richmond/Delta > Richmond/Delta
INSERT INTO MAP_NEAREST_TWN VALUES (175, 600);  --Riske Creek > Riske Creek
INSERT INTO MAP_NEAREST_TWN VALUES (220, 601);  --Roberts Creek > Roberts Creek
INSERT INTO MAP_NEAREST_TWN VALUES (143, 602);  --Rock Creek > Rock Creek
INSERT INTO MAP_NEAREST_TWN VALUES (194, 603);  --Rose Lake > Rose Lake
INSERT INTO MAP_NEAREST_TWN VALUES (128, 604);  --Rossland > Rossland
INSERT INTO MAP_NEAREST_TWN VALUES (91, 605);  --Ruskin > Ruskin
INSERT INTO MAP_NEAREST_TWN VALUES (260, 606);  --Rutland > Rutland
INSERT INTO MAP_NEAREST_TWN VALUES (188, 607);  --Saanich > Saanich
INSERT INTO MAP_NEAREST_TWN VALUES (301, 608);  --Saanich/Duncan > Saanich/Duncan
INSERT INTO MAP_NEAREST_TWN VALUES (104, 609);  --Salmo > Salmo
INSERT INTO MAP_NEAREST_TWN VALUES (31, 610);  --Salmon Arm > Salmon Arm
INSERT INTO MAP_NEAREST_TWN VALUES (302, 611);  --Savary Island > Savary Island
INSERT INTO MAP_NEAREST_TWN VALUES (239, 612);  --Savona > Savona
INSERT INTO MAP_NEAREST_TWN VALUES (182, 613);  --Sayward > Sayward
INSERT INTO MAP_NEAREST_TWN VALUES (218, 614);  --Sechelt > Sechelt
INSERT INTO MAP_NEAREST_TWN VALUES (246, 615);  --Seton Portage > Seton Portage
INSERT INTO MAP_NEAREST_TWN VALUES (234, 616);  --Shawnigan Lake > Shawnigan Lake
INSERT INTO MAP_NEAREST_TWN VALUES (32, 617);  --Sicamous > Sicamous
INSERT INTO MAP_NEAREST_TWN VALUES (189, 618);  --Sidney > Sidney
INSERT INTO MAP_NEAREST_TWN VALUES (96, 619);  --Silverton > Silverton
INSERT INTO MAP_NEAREST_TWN VALUES (73, 620);  --Skookumchuck > Skookumchuck
INSERT INTO MAP_NEAREST_TWN VALUES (99, 621);  --Slocan > Slocan
INSERT INTO MAP_NEAREST_TWN VALUES (199, 622);  --Smithers > Smithers
INSERT INTO MAP_NEAREST_TWN VALUES (209, 623);  --Sooke > Sooke
INSERT INTO MAP_NEAREST_TWN VALUES (226, 624);  --Sorrento > Sorrento
INSERT INTO MAP_NEAREST_TWN VALUES (94, 625);  --South Slocan > South Slocan
INSERT INTO MAP_NEAREST_TWN VALUES (35, 626);  --Spallumcheen > Spallumcheen
INSERT INTO MAP_NEAREST_TWN VALUES (149, 627);  --Sparwood > Sparwood
INSERT INTO MAP_NEAREST_TWN VALUES (83, 628);  --Spences Bridge > Spences Bridge
INSERT INTO MAP_NEAREST_TWN VALUES (232, 629);  --Spuzzum > Spuzzum
INSERT INTO MAP_NEAREST_TWN VALUES (17, 630);  --Squamish > Squamish
INSERT INTO MAP_NEAREST_TWN VALUES (245, 631);  --Squilax > Squilax
INSERT INTO MAP_NEAREST_TWN VALUES (136, 632);  --Stewart > Stewart
INSERT INTO MAP_NEAREST_TWN VALUES (291, 633);  --Stewrt > Stewrt
INSERT INTO MAP_NEAREST_TWN VALUES (60, 634);  --Summerland > Summerland
INSERT INTO MAP_NEAREST_TWN VALUES (12, 635);  --Surrey > Surrey
INSERT INTO MAP_NEAREST_TWN VALUES (208, 635);  --Surrey > Surrey  
INSERT INTO MAP_NEAREST_TWN VALUES (265, 636);  --Surrey, Langley > Surrey, Langley
INSERT INTO MAP_NEAREST_TWN VALUES (207, 637);  --Surrey/Cloverdale > Surrey/Cloverdale
INSERT INTO MAP_NEAREST_TWN VALUES (223, 638);  --Surrey/Richmond > Surrey/Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (306, 639);  --Tahsis > Tahsis
INSERT INTO MAP_NEAREST_TWN VALUES (230, 640);  --Tappen > Tappen
INSERT INTO MAP_NEAREST_TWN VALUES (173, 641);  --Tatla Lake > Tatla Lake
INSERT INTO MAP_NEAREST_TWN VALUES (39, 642);  --Taylor > Taylor
INSERT INTO MAP_NEAREST_TWN VALUES (140, 643);  --Telkwa > Telkwa
INSERT INTO MAP_NEAREST_TWN VALUES (4, 644);  --Terrace > Terrace
INSERT INTO MAP_NEAREST_TWN VALUES (197, 645);  --Tte Jaune Cache > Tête Jaune Cache
INSERT INTO MAP_NEAREST_TWN VALUES (268, 646);  --Tlell > Tlell
INSERT INTO MAP_NEAREST_TWN VALUES (124, 647);  --Tofino > Tofino
INSERT INTO MAP_NEAREST_TWN VALUES (195, 648);  --Topley > Topley
INSERT INTO MAP_NEAREST_TWN VALUES (126, 649);  --Trail > Trail
INSERT INTO MAP_NEAREST_TWN VALUES (157, 650);  --Trail/Rossland > Trail/Rossland
INSERT INTO MAP_NEAREST_TWN VALUES (162, 651);  --Tumbler Ridge > Tumbler Ridge
INSERT INTO MAP_NEAREST_TWN VALUES (125, 652);  --Ucluelet > Ucluelet
INSERT INTO MAP_NEAREST_TWN VALUES (185, 653);  --Union Bay > Union Bay
INSERT INTO MAP_NEAREST_TWN VALUES (304, 654);  --Unknown > Unknown
INSERT INTO MAP_NEAREST_TWN VALUES (115, 655);  --Valemount > Valemount
INSERT INTO MAP_NEAREST_TWN VALUES (116, 656);  --Valemount/Blue River > Valemount/Blue River
INSERT INTO MAP_NEAREST_TWN VALUES (112, 657);  --Valmount > Valmount
INSERT INTO MAP_NEAREST_TWN VALUES (11, 658);  --Vancouver > Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (263, 658);  --Vancouver > Vancouver  
INSERT INTO MAP_NEAREST_TWN VALUES (262, 659);  --Vancouver/Richmond > Vancouver/Richmond
INSERT INTO MAP_NEAREST_TWN VALUES (24, 660);  --Vancouver/West Vancouver > Vancouver/West Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (22, 661);  --Vancouver/Whistler > Vancouver/Whistler
INSERT INTO MAP_NEAREST_TWN VALUES (201, 662);  --Vanderhoof > Vanderhoof
INSERT INTO MAP_NEAREST_TWN VALUES (270, 663);  --Vanderhoof/Fraser Lake/Fort St James > Vanderhoof/Fraser Lake/Fort St James
INSERT INTO MAP_NEAREST_TWN VALUES (37, 664);  --Various > Various
INSERT INTO MAP_NEAREST_TWN VALUES (5, 664);  --Various > various
INSERT INTO MAP_NEAREST_TWN VALUES (114, 665);  --Vavenby > Vavenby
INSERT INTO MAP_NEAREST_TWN VALUES (48, 666);  --Vernon > Vernon
INSERT INTO MAP_NEAREST_TWN VALUES (190, 667);  --Victoria > Victoria
INSERT INTO MAP_NEAREST_TWN VALUES (295, 668);  --View Royal > View Royal
INSERT INTO MAP_NEAREST_TWN VALUES (275, 669);  --Walhachin > Walhachin
INSERT INTO MAP_NEAREST_TWN VALUES (160, 670);  --Wardner > Wardner
INSERT INTO MAP_NEAREST_TWN VALUES (127, 671);  --Warfield > Warfield
INSERT INTO MAP_NEAREST_TWN VALUES (36, 672);  --West Kelowna > West Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (62, 673);  --West Kelowna/Kelowna > West Kelowna/Kelowna
INSERT INTO MAP_NEAREST_TWN VALUES (16, 674);  --West Vancouver > West Vancouver
INSERT INTO MAP_NEAREST_TWN VALUES (61, 675);  --Westbank > Westbank
INSERT INTO MAP_NEAREST_TWN VALUES (253, 676);  --Westwold > Westwold
INSERT INTO MAP_NEAREST_TWN VALUES (7, 677);  --Whistler > Whistler
INSERT INTO MAP_NEAREST_TWN VALUES (18, 678);  --Whistler/Pemberton > Whistler/Pemberton
INSERT INTO MAP_NEAREST_TWN VALUES (46, 679);  --williams Lake > Williams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (55, 679);  --williams Lake > williams Lake
INSERT INTO MAP_NEAREST_TWN VALUES (311, 680);  --Windermere > Windermere
INSERT INTO MAP_NEAREST_TWN VALUES (95, 681);  --Winlaw > Winlaw
INSERT INTO MAP_NEAREST_TWN VALUES (193, 682);  --Witset > Witset
INSERT INTO MAP_NEAREST_TWN VALUES (179, 683);  --Woss > Woss
INSERT INTO MAP_NEAREST_TWN VALUES (155, 684);  --Yahk > Yahk
INSERT INTO MAP_NEAREST_TWN VALUES (238, 685);  --Yale > Yale
INSERT INTO MAP_NEAREST_TWN VALUES (103, 686);  --Ymir > Ymir
INSERT INTO MAP_NEAREST_TWN VALUES (277, 687);  --Youbou > Youbou
INSERT INTO MAP_NEAREST_TWN VALUES (296, 688);  --Zeballos > Zeballos

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

