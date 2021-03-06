----------------------------------create database Pharmacies----------------------------------

create table type
(
    id   serial not null,
    name varchar(50),
    primary key (id)
);

create table town
(
    id   serial      not null,
    name varchar(50) not null,
    primary key (id)
);

create table drugstore
(
    id     serial      not null,
    name   varchar(50) not null,
    adress varchar(50) not null,
    town varchar(50) not null,
    primary key (id)
);

create table fabricator
(
    id         serial not null,
    id_town    int    not null,
    phone      bigint not null,
    adress     varchar(50),
    primary key (id),
    foreign key (id_town) references town (id)
);

create table if not exists medicament
(
    id            serial      not null,
    name          varchar(50) not null,
    cost          numeric     not null,
    id_type       int         not null,
    id_fabricator int         not null,
    primary key (id),
    foreign key (id_type) references type (id),
    foreign key (id_fabricator) references fabricator (id)
);

create table avail_medicament
(
    id_med       int    not null,
    id_drugstore int    default null,
    count        int    default null,
    primary key (id_med, id_drugstore),
    foreign key (id_med) references medicament (id),
    foreign key (id_drugstore) references drugstore (id)
);

----------------------------Procedures-----------------------------
create or replace procedure new_medicament( name_med         varchar(50),
                                            type_name_med    varchar(50),
                                            cost_med         numeric,
                                            id_fab_med       integer,
                                            name_drugstore   varchar(50))
as $$
    declare
        drug_id integer:=0;
        id_of_med integer:=0;
        id_of_type integer:=0;
    begin
        if not exists(select type.name from type
        where type_name_med=type.name)
            then
            begin
            insert into type (name)
        values (type_name_med)
        returning id into id_of_type;
            end;
            else
            begin
               select type.id from type where type.name = type_name_med limit 1 into id_of_type;
            end;
        end if;

        if exists( select fabricator.id from fabricator
        where id_fab_med = fabricator.id::INTEGER)
        then
            begin
                insert into medicament (name, cost, id_type, id_fabricator)
                values (name_med,cost_med,id_of_type,id_fab_med)
                returning id into id_of_med;

                if exists(select drugstore.name from drugstore
        where name_drugstore=drugstore.name)
            then
            begin
               select drugstore.id from drugstore
               where drugstore.name = name_drugstore limit 1 into drug_id;
                insert into avail_medicament(id_med,id_drugstore,count)
                values (id_of_med,drug_id,null);
                end;
        end if;
                end;
            end if;
    end;
    $$
LANGUAGE plpgsql;


create or replace function  positive_price() returns trigger as $$
    begin
        if new.cost is null then
            raise exception 'cost cannot be null';
            end if;
        if new.cost<0 then
            raise exception '???? ??????????! ???????? ????????????????????';
            end if;
        return new;
    end;

$$ LANGUAGE plpgsql;

CREATE TRIGGER positive_price BEFORE INSERT OR UPDATE ON medicament
    FOR EACH ROW EXECUTE PROCEDURE positive_price();

create or replace function is_type(varchar(50))
returns table (name_of_type varchar(50), name_of_med varchar(50),cost_of_med numeric,name_of_fabricator varchar(50)) as $$
    begin
        return query
        select t.name, m.name,m.cost, c.name
        from type t
        join medicament m on t.id = m.id_type
        join fabricator f on f.id = m.id_fabricator
        join town c on c.id = f.id_town
        where t.name=$1;
    end;
    $$
language plpgsql;












