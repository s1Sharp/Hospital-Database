----------------------------------create database Hospital----------------------------------

create table if not exists Hospital
(
    id serial not null,
    name varchar(255) not null ,
    town varchar(255) ,
    adress varchar(255)  ,
    num_employees int ,
    num_petients int ,
    primary key (id)
);

create table if not exists Room
(
    id serial not null,
    hospital_id int not null references Hospital (id),
    room_num int not null,
    room_num_patients int constraint check_val check (room_num_patients>=0) default 0,
    primary key (id)
);
--alter table Room add column room_num_patients int constraint check_val check (room_num_patients>=0) default 0;


create table if not exists Patients
(
    id serial not null ,
    room_id int not null references Room(id),
    name varchar(255),
    surname varchar (255),
    age int DEFAULT 0,
    phone varchar(15),
    gender varchar(1) default null, --male or female (m,f)
    cash int default 100,
    primary key (id)
);
--alter table patients add column cash int default 100;


create table if not exists Employee
(
    id serial not null ,
    name varchar(255),
    surname varchar(255),
    category varchar(255),
    age int,
    gender varchar(1) default null, --male or female (m,f)
    primary key (id)
);


create table if not exists Diagnoses
(
    id                    serial not null,
    diagnos               varchar(255),
    primary key (id)
);


create table if not exists Treatment
(
    id serial not null,
    diagnos_id int references Diagnoses(id),
    medicament_id int references medicament(id),
    primary key (id)
);
--alter table treatment add foreign key (medicament_id) references medicament(id);

create table if not exists InfoCard
(
    id serial not null,
    patient_id int not null references Patients(id),
    treatment_id int not null references Treatment(id),
    specificity varchar(255),
    cur_time_of_treatment int,
    employee_treatment_id int not null references Employee(id),
    primary key (id)
);



/*drop table Treatment;drop table Diagnoses;drop table Employee;drop table Patients;drop table Info; drop table Room; drop table Hospital;*/
--------------------------------------------funtions---------------------------------------------------------------
create or replace procedure new_patient(    np_name         varchar(255),
                                            np_surname      varchar(255),
                                            np_age          integer,
                                            np_phone        varchar(15),
                                            np_gender       varchar(1), -- todo
                                            np_cash         integer,
                                            flag_gender     boolean,
                                            inout n_patient_id integer default 0,
                                            diagnos_name    varchar(50) default 'KORONA5', --'S923131',
                                            np_specificity varchar(255) default null
                                            )
as $$
    declare
        n_room_id               integer:=0;
        temp_hospital_id        integer:=0;
        temp_room_num           integer:=0;
        temp_town_name          varchar(50);
        n_treatment_id          integer:=0;
        n_epmloyee_treatment_id integer:=0;
        n_diagnos_id            integer:=0;
        n_medicament_id         integer:=0;

    begin
        select r.id from room as r
        where r.room_num_patients<2 limit 1 into n_room_id;
        /*return in here*/

        if n_room_id = null then

            select id,min(temp_room_num)as m from
                                      --select count room in "id" hospital--
            (select h.id,count(CASE when r.hospital_id = h.id then 1 else 0 end) as temp_room_num from hospital as h,room as r
            group by h.id,r.hospital_id
            having r.hospital_id = h.id) as e
                group by e.id
                order by m
                limit 1
                into temp_hospital_id;
                            --create new room with full clear places--
            PERFORM setval((select pg_get_serial_sequence('room', 'id'))::regclass, (SELECT max(id) FROM room));
             --before inserting set next serial sequence--
            insert into room(hospital_id, room_num) values (temp_hospital_id,(SELECT max(room_num) FROM room)::INTEGER + 1)
            returning room.id into n_room_id;
        end if;

        /*
        create new patient with trigger --create_new_patient()
        */
        PERFORM setval((select pg_get_serial_sequence('patients', 'id'))::regclass, (SELECT max(id) FROM patients));
        --before inserting set next serial sequence--
        insert into patients (room_id, name, surname, age, phone, gender,cash)
                    values  (n_room_id, np_name, np_surname, np_age, np_phone, np_gender,np_cash)
                    returning patients.id into n_patient_id;
        select h.id from hospital as h
        where  (select hospital_id from room where room.id = n_room_id) = h.id
        into temp_hospital_id;

        /*
        select employee for patient with minimal age different
        */
        CASE
            WHEN flag_gender = True then
            begin
                select e.id,min(abs(np_age-e.age))as m from employee as e
                where upper(np_gender) = e.gender
                group by e.id
                order by m
                limit 1
                into n_epmloyee_treatment_id;
            end;
            WHEN flag_gender = False then
            begin
                select e.id,min(abs(np_age-e.age))as m from employee as e
                group by e.id
                order by m
                limit 1
                into n_epmloyee_treatment_id;
            end;
            ELSE n_epmloyee_treatment_id = null;
        end case;

        /*
        select diagnos id and  medicament id for infocard with minimal name diagnos
        */
        select d.id from diagnoses as d
        where lower(diagnos_name::varchar(50)) = lower(d.diagnos::varchar(50)) into n_diagnos_id;
        --select  med_id for having in drugstore
        select a.id_med from avail_medicament as a
        right join drugstore d2 on (a.id_drugstore = (select d.id from drugstore as d
        where(select h.town as tw from hospital as h where temp_hospital_id = h.id limit 1) = d.town)and a.count>0) --14 is null
        group by a.id_med
        into n_medicament_id;
        --
        /*
        insert into treatment
        */
        PERFORM setval((select pg_get_serial_sequence('treatment', 'id'))::regclass, (SELECT max(id) FROM treatment));
        --before inserting set next serial sequence--
        insert into treatment (diagnos_id, medicament_id)
                        values(n_diagnos_id,  n_medicament_id)              -- floor(random() * 10 + 1)::int)
                        returning treatment.id into n_treatment_id;

        /*
        create new infocard
        */
        PERFORM setval((select pg_get_serial_sequence('infocard', 'id'))::regclass, (SELECT max(id) FROM infocard));
        --before inserting set next serial sequence--
        insert into infocard (patient_id, treatment_id, specificity, cur_time_of_treatment, employee_treatment_id)
                        values ( n_patient_id,n_treatment_id,np_specificity,1,n_epmloyee_treatment_id);
    end;
    $$
LANGUAGE plpgsql;
---------------------------------------------
create or replace function  create_new_patient() returns trigger as $$
    begin
        if new.age is null or new.age<1 then
            raise exception 'Cant create new patient, invalid age';
            end if;
        if new.cash < 0 then
            raise exception 'Cant create new patient, he isn`t rich :)';
            end if;
        if new.name is null or new.surname is null then
            raise exception 'Cant create new patient, null name or surname :)';
            end if;
        if new.gender != 'F' and  new.gender!='M' then
            if new.gender != 'f' and  new.gender !='m' then
                raise exception 'Cant create new patient, invalid gender';
            end if;
            new.gender = UPPER(new.gender);
            end if;
        begin
        update room r
        set room_num_patients = room_num_patients + 1
        where new.room_id = r.id;
        end;
        return new;
    end;
$$ LANGUAGE plpgsql;

CREATE TRIGGER create_new_patient BEFORE INSERT OR UPDATE ON patients
    FOR EACH ROW EXECUTE PROCEDURE create_new_patient();
---------------------------------------
create or replace function whose_employee(id_patient integer)
returns table (name_of_employee varchar(50),
               surname_of_employee varchar(50),
               gender_of_employee varchar(1),
               age_of_employee integer,
               name_of_patient varchar(50),
               surname_of_patient varchar(50),
               gender_of_patient varchar(1),
               age_of_patient integer
              )
as $$
    begin
        return query
        select e.name, e.surname, e.gender,e.age::INTEGER, p.name,p.surname, p.gender,p.age::INTEGER
        from employee as e left join (patients as p right join infocard as i on id_patient = i.patient_id)
        on e.id = i.employee_treatment_id
        where p.id = id_patient;
    end;
    $$
language plpgsql;

