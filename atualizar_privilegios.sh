function continuar {
	if [ "$(whoami)" != "postgres" ]; then
		echo "";
		echo "Esse script precisa ser executado pelo usuário postgres!";
		echo "";
		echo "Para mudar de usuário, use o comando \"su postgres\".";
		echo "";
	else
		atualizar;
	fi
}

function atualizar {
	echo "";
	
	read -p "Digite o nome do banco de dados: " nome;
	
	echo "";
	
	psql -d "$nome" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-0\";";
	psql -d "$nome" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT, INSERT, UPDATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-1\";";
	psql -d "$nome" -c "ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-2\";";
	
	echo "";
}

clear;
echo "Script atualizar privilégios após a criação de uma nova tabela.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
