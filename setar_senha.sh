function continuar {
	i=1;
	while [ $i -lt 4 ];
	do
		echo "Nova senha: ";
		stty -echo;
		read senha;
		stty echo;
		echo "Confirme a nova senha: ";
		stty -echo;
		read senha_c;
		stty echo;
		if [ "$senha" == "$senha_c" ]
		then
			sudo usermod -p $(openssl passwd -1 $senha) postgres;
			echo "";
			echo "Digite a senha definida anteriormente.";
			su -c "psql -c \"ALTER USER postgres WITH PASSWORD '${senha}'\";" -s /bin/sh postgres;
			i=4;
		else
			echo "";
			echo "As senhas não combinam!";
			let i=$i+1;
		fi
	done
}

clear;
echo "Script para setar a senha dos usuários postgres.";
echo "Isso vai modificar seu servidor!";
read -p "Continuar? [S/n] " escolha;
if [ "$escolha" == "s" ] || [ "$escolha" == "S" ];
then
	continuar;
else
	echo "Script abortado!";
fi
