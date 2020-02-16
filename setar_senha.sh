function continuar {
	for i in 1 2 3;
	do
		read -p "Nova senha: " senha;
		read -p "Confirme a nova senha: " senha_c;
		if [ "$senha" == "$senha_c" ]
		then
			sudo usermod -p $(openssl passwd -1 $senha) postgres;
			echo "";
			echo "Digite a senha do usuário postgres."; 
			su -c "psql -c \"ALTER USER postgres WITH PASSWORD '${senha}'\";" -s /bin/sh postgres;
			i=3;
		else
			echo "As senhas não combinam!";
		fi
	done
}

clear;
echo "Script para setar senha do banco de dados.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
