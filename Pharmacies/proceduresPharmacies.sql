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
            raise exception 'эй свышь! будь позитивным';
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

select is_type('SULFACETAMIDE SODIUM, SULFUR');
select is_type('CHLORCYCLIZINE HYDROCHLORIDE');