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

	psql -d "$nome" -c "REVOKE TRUNCATE ON ALL TABLES IN SCHEMA public FROM GROUP \"${nome}_nivel-0\";";
	psql -d "$nome" -c "REVOKE DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public FROM GROUP \"${nome}_nivel-1\";";
	psql -d "$nome" -c "REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public FROM GROUP \"${nome}_nivel-2\";";
	
	psql -d "$nome" -c "GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-0\";";
	psql -d "$nome" -c "GRANT SELECT, INSERT, UPDATE, REFERENCES, TRIGGER ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-1\";";
	psql -d "$nome" -c "GRANT SELECT ON ALL TABLES IN SCHEMA public TO GROUP \"${nome}_nivel-2\";";
}

clear;
echo "Script para atualizar privilégios após a criação de uma nova tabela.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
