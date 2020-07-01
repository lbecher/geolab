function continuar {
	if [ "$(whoami)" != "postgres" ]; then
		echo "";
		echo "Esse script precisa ser executado pelo usuário postgres!";
		echo "";
		echo "Para mudar de usuário, use o comando \"su postgres\".";
		echo "";
	else
		habilitar;
	fi
}

function habilitar {
        psql -c "CREATE EXTENSION postgis;";
        psql -c "CREATE EXTENSION postgis_raster;";
        psql -c "CREATE EXTENSION postgis_topology;";
        psql -c "CREATE EXTENSION postgis_sfcgal;";
        psql -c "CREATE EXTENSION fuzzystrmatch;";
        psql -c "CREATE EXTENSION address_standardizer;";
        psql -c "CREATE EXTENSION address_standardizer_data_us;";
        psql -c "CREATE EXTENSION postgis_tiger_geocoder;";
}

clear;
echo "Script para habilitar o PostGIS.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
