--------- data generated from https://mockaroo.com/ ---------

insert into type (id, name)
values (1, 'CHLORCYCLIZINE HYDROCHLORIDE');
insert into type (id, name)
values (2, 'Metoclopramide Hydrochloride');
insert into type (id, name)
values (3, 'Imipramine Hydrochloride');
insert into type (id, name)
values (4, 'ACETAMINOPHEN, CHLORPHENIRAMINE MALEATE ');
insert into type (id, name)
values (5, 'moxifloxacin hydrochloride');
insert into type (id, name)
values (6, 'ALPROSTADIL');
insert into type (id, name)
values (7, 'Ibuprofen, Pseudoephedrine Hydrochloride');
insert into type (id, name)
values (8, 'SULFACETAMIDE SODIUM, SULFUR');
insert into type (id, name)
values (9, 'ciprofloxacin hydrochloride');
insert into type (id, name)
values (10, 'Sertraline Hydrochloride');


insert into drugstore (id, name, adress,town)
values (1, 'ARMY AND AIR FORCE EXCHANGE SERVICE', '23458 Fordem Pass', 'Delaware');
insert into drugstore (id, name, adress,town)
values (2, 'Rite Aid Corporation', '54 Anderson Way', 'Northland');
insert into drugstore (id, name, adress,town)
values (3, 'Nash-Finch Company', '50563 Sunnyside Junction', 'Carey');
insert into drugstore (id, name, adress,town)
values (4, 'Carlsbad Technology, Inc.', '93 Paget Court', 'Iowa');
insert into drugstore (id, name, adress,town)
values (5, 'REMEDYREPACK INC.', '7155 Mesta Road', 'Michigan');
insert into drugstore (id, name, adress,town)
values (6, 'TIME CAP LABORATORIES, INC', '03576 Springview Place', 'Gateway');
insert into drugstore (id, name, adress,town)
values (7, 'Parfums Christian Dior', '38 1st Way', 'Monica');
insert into drugstore (id, name, adress,town)
values (8, 'Daiichi Sankyo, Inc.', '651 Ludington Park' ,'Dovetail');
insert into drugstore (id, name, adress,town)
values (9, 'Select Brand Distributors', '2 Quincy Way', 'Mallard');
insert into drugstore (id, name, adress,town)
values (10, 'Apotex Corp.', '30781 Hansons Trail', 'Commercial');


insert into town (id, name)
values (1, 'Delaware');
insert into town (id, name)
values (2, 'Northland');
insert into town (id, name)
values (3, 'Mallard');
insert into town (id, name)
values (4, 'Commercial');
insert into town (id, name)
values (5, 'Dovetail');
insert into town (id, name)
values (6, 'Monica');
insert into town (id, name)
values (7, 'Gateway');
insert into town (id, name)
values (8, 'Michigan');
insert into town (id, name)
values (9, 'Iowa');
insert into town (id, name)
values (10, 'Carey');


insert into fabricator (id, id_town, phone, adress)
values (1, 1, '7224628868', '205 Pennsylvania Street');
insert into fabricator (id, id_town, phone, adress)
values (2, 2, '5342279107', '31536 Kim Pass');
insert into fabricator (id, id_town, phone, adress)
values (3, 3, '5043533997', '2 Del Mar Road');
insert into fabricator (id, id_town, phone, adress)
values (4, 4, '6964461576', '39 Porter Trail');
insert into fabricator (id, id_town, phone, adress)
values (5, 5, '4242247304', '691 Vidon Place');
insert into fabricator (id, id_town, phone, adress)
values (6, 6, '8605578634', '7897 Magdeline Alley');
insert into fabricator (id, id_town, phone, adress)
values (7, 7, '3008348017', '5719 Michigan Park');
insert into fabricator (id, id_town, phone, adress)
values (8, 8, '8111324731', '05 Buhler Crossing');
insert into fabricator (id, id_town, phone, adress)
values (9, 9, '5832964177', '51412 Larry Road');
insert into fabricator (id, id_town, phone, adress)
values (10, 10, '9762968197', '98 Brentwood Point');
insert into fabricator (id, id_town, phone, adress)
values (11, 10, '976293268197', '94 Brentwood Point');
insert into fabricator (id, id_town, phone, adress)
values (12, 10, '9762968197', '97 Brentwood Point');


insert into medicament (id, name, cost, id_type, id_fabricator)
values (1, 'Pioglitazone Hydrochloride', 591.74, 1, 1);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (2, 'Colgate', 250.59, 2, 2);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (3, 'Benztropine Mesylate', 286.05, 3, 3);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (4, 'SHAKING SMOOTHIE LEMON MASK', 728.25, 4, 4);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (5, 'Dr. Pearsalls 500 Calorie Diet', 714.62, 5, 5);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (6, 'GERI-TUSSIN EXPECTORANT', 345.35, 6, 6);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (7, 'SPA Mystique Skin Protection', 561.8, 7, 7);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (8, 'UV Capture Vita Sun Gel', 576.85, 8, 8);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (9, 'Ammonium Lactate', 643.09, 9, 9);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (10, 'Ibuprofen1', 634.6, 1, 10);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (11, 'Ibuprofen2', 64.6, 2, 10);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (12, 'Ibuprofen3', 634.6, 3, 8);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (13, 'Ibuprofen4', 63.6, 1, 7);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (14, 'Ibuprofen1', 63.6, 1, 9);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (15, 'Ibuprofen5', 63.6, 1, 11);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (16, 'Ibuprofen6', 63.6, 1, 11);
insert into medicament (id, name, cost, id_type, id_fabricator)
values (17, 'Ibuprofen7', 63.6, 1, 12);


insert into avail_medicament (id_med, id_drugstore, count)
values (1, 1, 59);
insert into avail_medicament (id_med, id_drugstore, count)
values (2, 9, 95);
insert into avail_medicament (id_med, id_drugstore, count)
values (3, 7, 11);
insert into avail_medicament (id_med, id_drugstore, count)
values (4, 8, 53);
insert into avail_medicament (id_med, id_drugstore, count)
values (5, 6, 16);
insert into avail_medicament (id_med, id_drugstore, count)
values (6, 3, 0);
insert into avail_medicament (id_med, id_drugstore, count)
values (7, 2, 0);
insert into avail_medicament (id_med, id_drugstore, count)
values (8, 4, 47);
insert into avail_medicament (id_med, id_drugstore, count)
values (9, 1, 43);
insert into avail_medicament (id_med, id_drugstore, count)
values (10, 2, 30);

