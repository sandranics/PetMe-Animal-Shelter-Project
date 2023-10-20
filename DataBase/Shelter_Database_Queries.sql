
------- Примерни с прости заявки -----------

--Напишете заявка, която показва името на животното с идентификационен номер 12332
SELECT a.ANIMAL_NAME
FROM ANIMALS a
WHERE a.ANIMAL_ID=12332

--Напишете заявка, която показва имената на приютите в Шумен
SELECT s.NAME
FROM SHELTERS s
WHERE s.TOWN_NAME='Shumen'

--Напишете заявка, която показва имената на кучетата от порода лабрадор
SELECT a.ANIMAL_NAME
FROM ANIMALS a
WHERE a.SPECIES='Dog'
AND a.BREED='Labrador'

--Напишете заявка, която показва в кои градове има приюти, сортирани по имена
SELECT DISTINCT s.TOWN_NAME
FROM SHELTERS s
ORDER BY s.TOWN_NAME

--Напишете заявка, която показва идентификационните номера и имената на персонала, работещи в градове, започващи с В (V)
SELECT p.PRIVATE_ID as PersonnelID, p.NAME as PersonnelName
FROM PERSONNEL p
WHERE p.TOWN_NAME LIKE 'V%'


------- Примери със заявки върху две и повече релации -------

--Напишете заявка, която извежда имената на клиентите, които са дали животинче за осиновяване на приют в град София.
SELECT c.NAME
FROM CLIENTS c, GIVES_FOR_ADOPTION g, SHELTERS s
WHERE c.CLIENT_ID=g.CLIENT_ID
AND g.SHELTER_ADDRESS=s.ADDRESS
AND g.TOWN_NAME=s.TOWN_NAME
AND s.TOWN_NAME='Sofia'

--Напишете заявка, която да изведе идентификационните номера на гледачите на животни с имена "Doug" (животните са с това име).
SELECT ak.PRIVATE_ID
FROM ANIMAL_KEEPERS ak, TAKES_CARE tc, ANIMALS a
WHERE ak.PRIVATE_ID=tc.PRIVATE_ID
AND tc.ANIMAL_ID=a.ANIMAL_ID
AND a.ANIMAL_NAME='Doug'

--Напишете заявка, която показва името, телефонния номер на хората и града им, работещи в приют с име "Animal Care".
SELECT p.NAME, p.PHONE_NUMBER
FROM PERSONNEL p, SHELTERS s
WHERE p.SHELTER_ADDRESS=s.ADDRESS
AND p.TOWN_NAME=s.TOWN_NAME
AND s.NAME='Animal Care'

--Напишете заявка, която показва името, породата и вида на животните, които са в приюта  с име "PetMe" в София.
SELECT a.ANIMAL_NAME, a.BREED, a.SPECIES
FROM ANIMALS a, SHELTERS s
WHERE a.SHELTER_ADDRESS=s.ADDRESS
AND a.TOWN_NAME=s.TOWN_NAME
AND s.NAME='PetMe'
AND s.TOWN_NAME='Sofia'

--Напишете заявка, която показва имената на папагалите, които са по-възрастни от животното с идентификационен номер 12332.
SELECT a.ANIMAL_NAME
FROM ANIMALS a, ANIMALS a1
WHERE a.SPECIES='Parrot'
AND a1.ANIMAL_ID=12332
AND a.AGE>a1.AGE




------- Примери с подзаявки -------

--Изведете породата на тези животни, чийто приют не е в София.
--Тази заявка извежда породите на животните от приютите извън град София.
select breed
  from animals
 where TOWN_NAME not in (select TOWN_NAME
				  from SHELTERS
				 where TOWN_NAME='Sofia')

--Изведете имената на тези приюти, които са в градове, където адресът на приюта е
--на улица Сан Стефано.
select name
  from Shelters
 where TOWN_NAME in (select TOWN_NAME
				  from PERSONNEL
				 where SHELTER_ADDRESS='San Stefano')

--Изведете градовете, посещавани от доброволци.
--Тази заявка извежда имената само на тези градовете, които биват посещавани от доброволци.
select TOWN_NAME
  from visits
 where CLIENT_ID in (select CLIENT_ID
				  from CLIENTS
				 where TYPE_CLIENT='volunteer')

--Изведете града, в който приютът е на адреса, от който е осиновен Зузи.
--Тази заявка извежда името на града, където се намира адресът, от който е осиновен домашният любимец Зузи.
select TOWN_NAME
from shelters
 where ADDRESS in (select SHELTER_ADDRESS
				  from adopts
				 where ANIMAL='Zuzi')

--Изведете адреса на приюта, където Зузи е даден за осиновяване.
--Тази заявка извежда адреса на приюта, в който Зузи е бил оставен за осиновяване.
select g.SHELTER_ADDRESS
from GIVES_FOR_ADOPTION g, SHELTERS s
 where s.ADDRESS=g.SHELTER_ADDRESS and s.TOWN_NAME=g.TOWN_NAME and s.ADDRESS in (select SHELTER_ADDRESS
										from adopts
										where ANIMAL='Zuzi')



------- Примери със съединения -------

-- Извежда клиентите с местонахождение София
SELECT c.CLIENT_ID, c.NAME
FROM CLIENTS c
JOIN VISITS v ON c.CLIENT_ID = v.CLIENT_ID
WHERE TOWN_NAME = 'Sofia';

-- Извежда клиентите, които са дали животни за осиновяване в София
SELECT c.CLIENT_ID, c.NAME, gfa.ANIMAL, gfa.DATE
FROM CLIENTS c
JOIN GIVES_FOR_ADOPTION gfa ON c.CLIENT_ID = gfa.CLIENT_ID
WHERE gfa.TOWN_NAME = 'Sofia';

-- Извежда приютите, които НЕ се грижат за хамстери и зайци
SELECT s.NAME, s.ADDRESS, s.TOWN_NAME
FROM SHELTERS s
JOIN ANIMALS a ON s.ADDRESS = a.SHELTER_ADDRESS
WHERE a.SPECIES NOT IN ('Hamster', 'Rabbit');

-- Извежда персонала, чийто приют се грижи за котки или кучета
SELECT p.PRIVATE_ID, p.NAME, s.NAME
FROM PERSONNEL p
JOIN SHELTERS s ON p.SHELTER_ADDRESS = s.ADDRESS
JOIN ANIMALS a ON s.ADDRESS = a.SHELTER_ADDRESS
WHERE a.SPECIES = 'Dog' OR a.SPECIES = 'Cat'; 

-- Извежда животните, които са осиновени от клиенти, чиито клиентски номера започват с 3
SELECT a.ANIMAL_ID, a.ANIMAL_NAME, c.CLIENT_ID, c.NAME
FROM ANIMALS a
JOIN SHELTERS s ON a.SHELTER_ADDRESS = s.ADDRESS
JOIN ADOPTS ad ON ad.SHELTER_ADDRESS = s.ADDRESS
JOIN CLIENTS c ON c.CLIENT_ID = ad.CLIENT_ID
WHERE c.CLIENT_ID LIKE '3%';



------- Примери с групиране и аграгация -------

--Изведете броя и имената на всички котки групирани по име
Select a.ANIMAL_NAME, COUNT(a.SPECIES) as SPECIES_COUNT from ANIMALS a
where a.SPECIES='Cat'
group by a.ANIMAL_NAME

-------------------------------------------------------------
--Изведете броя на различните породи животни в приютите в София
Select COUNT(a.BREED) as BREED_COUNT 
from ANIMALS a join SHELTERS s on  a.SHELTER_ADDRESS=s.ADDRESS and a.TOWN_NAME=s.TOWN_NAME
where s.TOWN_NAME='Sofia'

------------------------------------------------------------
--Изведете имената и ИД-тата на целия персонал групирани по ИД и име
Select p.PRIVATE_ID, p.NAME from PERSONNEL p
group by p.PRIVATE_ID,p.NAME

---------------------------------------------------
--Изведете броя на приютите в град Варна
Select count(ADDRESS) as ADDRESS_COUNT from SHELTERS s
where s.TOWN_NAME='Varna'

-----------------------------------------------------------
--Изведете броят на кучетата в приют с адрес София, Джеймс Баучер 14
select s.ADDRESS, s.TOWN_NAME, COUNT(a.SPECIES) as SPECIES_COUNT from ANIMALS a
join SHELTERS s on s.ADDRESS=a.SHELTER_ADDRESS and s.TOWN_NAME=a.TOWN_NAME
where s.TOWN_NAME='Sofia' and s.ADDRESS='James Boucher 14' and a.SPECIES='dog'
group by s.ADDRESS, s.TOWN_NAME

--------------------------------------------------------------

--Изведете броя на хората от персонала в приюта "" в София
Select count(p.PRIVATE_ID) as PEOPLE_COUNT from PERSONNEL p
join SHELTERS s on  p.SHELTER_ADDRESS=s.ADDRESS and p.TOWN_NAME=s.TOWN_NAME
where  s.ADDRESS='James Boucher 14' and s.TOWN_NAME='Sofia'

----------------------------------------------------------------
--Изведете имената на осиновителите, които са осиновили поне 2 животни
select c.NAME, c.CLIENT_ID from CLIENTS c 
join ADOPTS ad on c.CLIENT_ID=ad.CLIENT_ID
group by c.NAME, c.CLIENT_ID
having count(ad.ANIMAL)>=2

-----------------------------------------------------------------
--Изведете адресите и броя на работещия персонал във всеки приют
Select s.TOWN_NAME, s.ADDRESS, count(p.PRIVATE_ID) as PERSONEL_NUMBER from PERSONNEL p
join SHELTERS s on  p.SHELTER_ADDRESS=s.ADDRESS and p.TOWN_NAME=s.TOWN_NAME
group by s.ADDRESS, s.TOWN_NAME

--------------------------------------------------------------
--Изведете името на приюта и от колко човека е бил посетен
select s.NAME, COUNT(c.CLIENT_ID) as CLIENTS_NUMBER from SHELTERS s
join VISITS c on s.ADDRESS=c.SHELTER_ADDRESS and s.TOWN_NAME=c.TOWN_NAME
group by s.NAME

-----------------------------------------------
--Изведете имената на най- посещаваните приюти 
select ss.NAME from SHELTERS ss
join VISITS v on ss.ADDRESS=v.SHELTER_ADDRESS and ss.TOWN_NAME=v.TOWN_NAME 
group by name
having COUNT (v.CLIENT_ID)>=ALL(
select COUNT(c.CLIENT_ID)from SHELTERS s
join VISITS c on s.ADDRESS=c.SHELTER_ADDRESS and s.TOWN_NAME=c.TOWN_NAME 
group by s.NAME)

---------------------------------------------------------------------
--Изведете имената на приютите с най- много животни в тях
select ss.NAME from SHELTERS ss
join ANIMALS a on ss.ADDRESS=a.SHELTER_ADDRESS and ss.TOWN_NAME=a.TOWN_NAME 
group by ss.NAME
having COUNT (a.ANIMAL_ID)>=ALL(
select COUNT(c.ANIMAL_ID)from SHELTERS s
join ANIMALS c on s.ADDRESS=c.SHELTER_ADDRESS and s.TOWN_NAME=c.TOWN_NAME 
group by s.NAME)