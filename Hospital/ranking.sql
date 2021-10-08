-----------------create ranking hospital by count of patients-----------------

--drop database hospital;
select * from hospital.public.hospital;select * from hospital.public.room;

with RatingStore as(
    select distinct h.id,h.name,sum(r.room_num_patients)  over (partition by h.id) as patient_count
    from hospital.public.hospital h
    join hospital.public.room r on h.id = r.hospital_id)

select RS.*, DENSE_RANK() over (order by RS.patient_count desc) as ranking
from RatingStore as RS
order by ranking;

--drop view patients_count;
create or replace view patients_count as (
select r.hospital_id             as hospital_id,
       h.name                    as hospital_name,
       sum(r.room_num_patients)  as p_count
from room r
    join hospital h on r.hospital_id = h.id
    group by hospital_id,hospital_name
    order by p_count desc
         );

create or replace view patients_count_compare as(
select pc.hospital_name as hospital_name_left,
       pc.p_count as left_count,
       pc_right.p_count as right_count,
       pc_right.hospital_name as hospital_name_right
from patients_count as pc
left join patients_count as pc_right
on pc.p_count < pc_right.p_count
);




--drop view patients_count_rating
create or replace view patients_count_rating as
    (
    select pcc.left_count as cnt, count(distinct pcc.right_count) as rating
    from patients_count_compare as pcc
    group by pcc.left_count
    );



select pc.hospital_id,pc.hospital_name,pcr.cnt,pcr.rating+1 as ranking
from patients_count as pc
join patients_count_rating as pcr on pc.p_count=pcr.cnt
order by ranking;

--------------------drow views-----------------------

drop view patients_count_rating;
drop view patients_count_compare;
drop view patients_count;