function continuar {
	i=1;
	while [ $i -lt 4 ];
	do
		read -p "Nova senha: " senha;
		read -p "Confirme a nova senha: " senha_c;
		if [ "$senha" == "$senha_c" ]
		then
			sudo usermod -p $(openssl passwd -1 $senha) postgres;
			echo "";
			echo "Digite a senha definida anteriormente.";
			su -c "psql -c \"ALTER USER postgres WITH PASSWORD '${senha}'\";" -s /bin/sh postgres;
			i=4;
		else
			echo "As senhas não combinam!";
			let i=$i+1;
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
