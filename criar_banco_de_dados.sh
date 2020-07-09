function continuar {
	if [ "$(whoami)" != "postgres" ]; then
		echo "";
		echo "Esse script precisa ser executado pelo usuário postgres!";
		echo "";
		echo "Para mudar de usuário, use o comando \"su postgres\".";
		echo "";
	else
		criar_bd;
	fi
}

function criar_bd {
	echo "";
	
	read -p "Digite um nome para o novo banco de dados: " nome;
	
	psql -c "CREATE DATABASE \"$nome\" WITH ENCODING = 'UTF8' CONNECTION LIMIT = -1;";
	
	psql -c "CREATE GROUP \"${nome}_nivel-0\";";
	psql -c "CREATE GROUP \"${nome}_nivel-1\";";
	psql -c "CREATE GROUP \"${nome}_nivel-2\";";
	
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT USAGE ON SCHEMA %I TO \"${nome}_nivel-0\" \$\$, sch); END LOOP; END; \$do\$;"
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT USAGE ON SCHEMA %I TO \"${nome}_nivel-1\" \$\$, sch); END LOOP; END; \$do\$;"
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT USAGE ON SCHEMA %I TO \"${nome}_nivel-2\" \$\$, sch); END LOOP; END; \$do\$;"

	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ REVOKE TRUNCATE ON ALL TABLES IN SCHEMA %I FROM GROUP \"${nome}_nivel-0\" \$\$, sch); END LOOP; END; \$do\$;";
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ REVOKE DELETE, TRUNCATE ON ALL TABLES IN SCHEMA %I FROM GROUP \"${nome}_nivel-1\" \$\$, sch); END LOOP; END; \$do\$;";
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA %I FROM GROUP \"${nome}_nivel-2\" \$\$, sch); END LOOP; END; \$do\$;";
	
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA %I TO GROUP \"${nome}_nivel-0\" \$\$, sch); END LOOP; END; \$do\$;";
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT SELECT, INSERT, UPDATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA %I TO GROUP \"${nome}_nivel-1\" \$\$, sch); END LOOP; END; \$do\$;";
	psql -d "$nome" -c "DO \$do\$ DECLARE sch text; BEGIN FOR sch IN SELECT nspname FROM pg_namespace LOOP EXECUTE format(\$\$ GRANT SELECT ON ALL TABLES IN SCHEMA %I TO GROUP \"${nome}_nivel-2\" \$\$, sch); END LOOP; END; \$do\$;";
}

clear;
echo "Script para criar banco de dados.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
