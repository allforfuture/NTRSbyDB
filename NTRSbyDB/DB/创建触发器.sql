-- FUNCTION: public.update_group()

-- DROP FUNCTION public.update_group();

CREATE FUNCTION public.update_group()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$DECLARE
	v_line INTEGER;
	v_inner_welding_time TIMESTAMP WITH TIME ZONE;
	v_production_stage TEXT;
	v_result TEXT;
	
BEGIN
	v_line:=NEW.line;
	v_inner_welding_time:=NEW.inner_welding_time;
	v_production_stage:=NEW.production_stage;
	
	IF v_line =5
		THEN BEGIN
		--IF v_inner_welding_time between '2019-08-15' and '2019-08-21'
		IF v_inner_welding_time>= '2019-08-15' and v_inner_welding_time <= '2019-08-20'
			THEN v_result='Bin B';
		ELSE BEGIN
			IF v_production_stage='A'
				THEN v_result='Bin A';
			ELSEIF v_production_stage='8'
				THEN v_result='Bin C';
			ELSE v_result=NULL;
			RAISE NOTICE 'Error:production_stage';
			END IF;
			END;
		END IF;
		END;
		
    ELSEIF v_line IN (2,3,4,6)
		THEN BEGIN
		IF v_production_stage='A'
				THEN v_result='Bin A';
			ELSEIF v_production_stage='8'
				THEN v_result='Bin C';
			ELSE v_result=NULL;
			RAISE NOTICE 'Error:production_stage';
		END IF;
		END;
    ELSE
		v_result:=NULL;
        RAISE notice 'Error:line';
    END IF;
	
	INSERT INTO result_sn(sn, sn_group,update_time,line,inner_welding_time,production_stage)
	VALUES (NEW.sn, v_result,NOW(),v_line,v_inner_welding_time,v_production_stage);
	RETURN NEW;
END;$BODY$;

ALTER FUNCTION public.update_group()
    OWNER TO postgres;
